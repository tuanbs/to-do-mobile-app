CREATE TABLE "AppUsers" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_AppUsers" PRIMARY KEY AUTOINCREMENT,
    "Guid" TEXT NOT NULL,
    "CreatedDate" TEXT NOT NULL,
    "UpdatedDate" TEXT NOT NULL,
    "IsDeleted" INTEGER NULL DEFAULT 0,
    "AccessFailedCount" INTEGER NULL,
    "Email" TEXT NULL,
    "Gender" TEXT NULL,
    "PhoneNumber" TEXT NULL,
    "UserName" TEXT NULL,
    "DateOfBirth" TEXT NULL,
    "FirstName" TEXT NULL,
    "MiddleName" TEXT NULL,
    "LastName" TEXT NULL
);

CREATE TABLE "ToDos" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_ToDos" PRIMARY KEY AUTOINCREMENT,
    "Guid" TEXT NOT NULL,
    "CreatedDate" TEXT NOT NULL,
    "UpdatedDate" TEXT NOT NULL,
    "IsDeleted" INTEGER NULL DEFAULT 0,
    "Description" TEXT NOT NULL,
    "IsDone" INTEGER NULL DEFAULT 0,
    "AppUserId" INTEGER NULL,
    CONSTRAINT "FK_ToDos_AppUsers_AppUserId" FOREIGN KEY ("AppUserId") REFERENCES "AppUsers" ("Id") ON DELETE RESTRICT
);

CREATE UNIQUE INDEX "IX_AppUsers_Email" ON "AppUsers" ("Email");

CREATE UNIQUE INDEX "IX_AppUsers_Guid" ON "AppUsers" ("Guid");

CREATE UNIQUE INDEX "IX_AppUsers_UserName" ON "AppUsers" ("UserName");

CREATE INDEX "IX_ToDos_AppUserId" ON "ToDos" ("AppUserId");

CREATE UNIQUE INDEX "IX_ToDos_Guid" ON "ToDos" ("Guid");

---------- Insert some sample data.
Insert Or Replace Into ToDos(Id, [Guid], CreatedDate, UpdatedDate, [Description], IsDone) Values (1, lower(hex(randomblob(16))), datetime('now'), datetime('now'), "Learn Swift", 0);
Insert Or Replace Into ToDos(Id, [Guid], CreatedDate, UpdatedDate, [Description], IsDone) Values (2, lower(hex(randomblob(16))), datetime('now'), datetime('now'), "Learn Flutter", 1);
Insert Or Replace Into ToDos(Id, [Guid], CreatedDate, UpdatedDate, [Description], IsDone) Values (3, lower(hex(randomblob(16))), datetime('now'), datetime('now'), "Learn .Net Core", 0);