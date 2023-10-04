import { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable('user_app_permissions', table => {
    table.increments('id');
    table.integer('app_id').unsigned().notNullable().comment('Reference to the app / OAuth2 client');
    table.integer('user_id').unsigned().notNullable().comment('User / Resource owner');
    table.string('scope', 1024).comment('Scopes that were requested');
    table.bigint('created_at').unsigned().notNullable().comment('When the user first gave permission to the app');
    table.bigint('modified_at').unsigned().notNullable().comment('Last time the set of permissions were changed');
    table.bigint('last_used_at').unsigned().nullable().comment('Last time this application issued or refreshed an access token');
    table.unique(['app_id', 'user_id']);
    table.comment('This table lists the permissions that user have given to apps');
  });

}

export async function down(knex: Knex): Promise<void> {

  await knex.schema.dropTable('user_app_permissions');

}
