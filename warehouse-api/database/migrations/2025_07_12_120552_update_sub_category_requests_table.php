<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('sub_category_requests', function (Blueprint $table) {
            $table->enum('action', ['add', 'delete'])->default('add')->after('category_id');
            $table->unsignedBigInteger('sub_category_id')->nullable()->after('name');
            $table->foreign('sub_category_id')->references('id')->on('sub_categories')->nullOnDelete();
            $table->string('name')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
