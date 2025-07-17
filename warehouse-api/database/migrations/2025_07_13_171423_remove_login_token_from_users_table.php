<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class RemoveLoginTokenFromUsersTable extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('login_token');
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('login_token')->nullable();
        });
    }
}

