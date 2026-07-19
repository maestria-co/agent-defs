# Writing Tests — Edge Cases & Testability Blockers

**See also**: [`../SKILL.md`](../SKILL.md) | [`../../implementing-features/SKILL.md`](../../implementing-features/SKILL.md)

**In this guide:**
- When testing is blocked: what it means
- 5 patterns that block testing (and how to unblock)
- Output format when code is untestable

---

## When Testing Is Blocked: What It Means

Testing is blocked when the code under test cannot be isolated from its dependencies. This typically happens when:

- The code imports a global singleton and uses it directly (no injection point)
- The code has hard-coded external service calls
- The code has circular dependencies that prevent mocking
- The code mixes concerns (business logic + I/O + external calls)

**Untestable code requires refactoring before tests can be written.** This is not a test problem; it's a code design problem. Route the refactoring to the `implementing-features` skill.

---

## Pattern 1: Global Singletons (Redis, Database, Logger)

**The problem:**

```javascript
// src/services/tokenRefresh.js — UNTESTABLE
import redisClient from '../lib/redis'; // global singleton

export function refreshToken(userId) {
  // Cannot mock redisClient; it's imported directly and used globally
  return redisClient.get(`token:${userId}`);
}
```

Tests cannot mock `redisClient` without mocking the implementation itself, which violates the testing principle: test the contract (behavior), not the internals.

**Why it fails:** When you try to mock the Redis client in your test setup, you're mocking the module internals. If the actual code changes how it calls Redis, the test may pass even though the real code is broken.

**Example: Test blocked**

```
Tests: ❌ Blocked
Reason: src/services/tokenRefresh.js imports Redis client as a module-level singleton
with no injection point. Cannot mock the Redis client without mocking the implementation
itself, which tests internals rather than behavior.

Suggested next: implementing-features — refactor tokenRefresh.js to accept a redis
client as a constructor/function parameter, then return to writing-tests.
```

**How to unblock:** Use dependency injection. Accept the Redis client as a parameter:

```javascript
// src/services/tokenRefresh.js — TESTABLE
export function refreshToken(userId, redisClient) {
  return redisClient.get(`token:${userId}`);
}

// Tests can now inject a mock Redis client:
const mockRedis = { get: jest.fn().mockResolvedValue('token123') };
const result = await refreshToken(42, mockRedis);
```

---

## Pattern 2: Hard-Coded External Service Calls

**The problem:**

```javascript
// src/services/stripe.js — UNTESTABLE
import Stripe from 'stripe';

export function chargeCard(amount) {
  const stripe = new Stripe(process.env.STRIPE_KEY);
  // Direct call to Stripe; cannot be mocked or substituted
  return stripe.charges.create({ amount });
}
```

Tests cannot verify behavior without actually calling Stripe (expensive, unreliable, pollutes data).

**How to unblock:** Accept the Stripe client (or a mock thereof) as a parameter:

```javascript
// src/services/stripe.js — TESTABLE
export function chargeCard(amount, stripeClient) {
  return stripeClient.charges.create({ amount });
}

// Tests can inject a mock:
const mockStripe = { charges: { create: jest.fn().mockResolvedValue({ id: 'ch_123' }) } };
const result = await chargeCard(1000, mockStripe);
```

---

## Pattern 3: Circular Dependencies

**The problem:**

```javascript
// src/models/User.js
import { sendEmail } from '../services/email';
module.exports = { User, sendNotification };

// src/services/email.js
import { User } from '../models/User';
// Circular: User imports email, email imports User
```

Circular dependencies cause issues when trying to mock modules in tests.

**How to unblock:** Refactor to remove the cycle. Break the dependency chain by:
- Creating a third module that both depend on
- Passing the dependency as a parameter instead of importing it
- Using lazy imports within functions (not at module level)

---

## Pattern 4: Mixed Concerns (Business Logic + I/O)

**The problem:**

```javascript
// src/services/orderProcessor.js — UNTESTABLE
export async function processOrder(orderId) {
  // Business logic mixed with I/O
  const order = await db.orders.findById(orderId); // cannot mock
  const user = await db.users.findById(order.userId); // cannot mock
  const result = validateOrder(order); // can test
  const receipt = await stripe.charges.create(...); // cannot mock
  // All mixed together; cannot test business logic in isolation
}
```

Tests are forced to either mock internals or make real external calls.

**How to unblock:** Separate business logic from I/O. Pass data and external services as parameters:

```javascript
// src/services/orderProcessor.js — TESTABLE
export function processOrder(order, user, chargeFunction) {
  // Pure business logic: takes data + injectable functions
  const result = validateOrder(order);
  return { ...result, chargeResult: chargeFunction(user.id, order.amount) };
}

// Tests can pass test data and mock functions:
const mockCharge = jest.fn().mockResolvedValue({ id: 'ch_123' });
const result = await processOrder(testOrder, testUser, mockCharge);
```

---

## Pattern 5: Uninitialized or Missing Dependencies

**The problem:**

```javascript
// src/models/User.js — UNTESTABLE
class User {
  save() {
    return database.save(this); // `database` is never passed in; implicitly global
  }
}
```

No way to inject a test database or mock. The object assumes `database` exists globally.

**How to unblock:** Pass dependencies to the constructor:

```javascript
// src/models/User.js — TESTABLE
class User {
  constructor(data, database) {
    this.data = data;
    this.database = database;
  }
  
  save() {
    return this.database.save(this);
  }
}

// Tests can inject a mock database:
const mockDb = { save: jest.fn().mockResolvedValue({ id: 1 }) };
const user = new User({ name: 'Alice' }, mockDb);
await user.save();
```

---

## How to Report Blocked Testing

When you encounter untestable code, use this format:

```
Tests: ❌ Blocked
Reason: [Specific pattern + file:line]

Pattern: [One of the 5 patterns above]
Details: [Why this code cannot be tested]

Suggested next: implementing-features — refactor [file] to [solution], then return to writing-tests
```

**Example:**

```
Tests: ❌ Blocked
Reason: src/services/tokenRefresh.js:15 — Redis client is a module-level singleton
with no injection point

Pattern: Global singletons (Pattern 1)
Details: The function imports redisClient directly and calls it. Tests cannot mock
redisClient without mocking the module internals, violating the contract-based
testing principle.

Suggested next: implementing-features — refactor tokenRefresh.js to accept a
redis client as a function parameter, then return to writing-tests.
```

---

## See Also

- **implementing-features skill** — use this to refactor untestable code
- **Constraints** in main SKILL.md — the principle: do not mock the code under test
- **Pre-flight Checks** in main SKILL.md (Check 2) — find existing test patterns before writing new tests

