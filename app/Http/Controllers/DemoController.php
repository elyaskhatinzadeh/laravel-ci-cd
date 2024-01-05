<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class DemoController extends Controller
{
    public function index()
    {
        User::factory(1)->create();
        $users = User::all();
        return response()->json([
            'users' => $users
        ]);
    }
}
