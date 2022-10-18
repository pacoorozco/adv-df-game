@extends('layouts.master')

{{-- Web site Title --}}
@section('title', __('site.play'))

{{-- Content Header --}}
@section('header')
    {{ __('site.play') }}
@endsection

{{-- Breadcrumbs --}}
@section('breadcrumbs')
    <li>
        <a href="{{ route('home') }}">
            <i class="fa fa-dashboard"></i> {{ __('site.home') }}
        </a>
    </li>
    <li class="active">
        {{ __('site.play') }}
    </li>
@endsection

{{-- Content --}}
@section('content')
    <div class="box box-default">
        <div class="box-body">

            <!-- user metrics -->
            <div class="row">
                <div class="col-md-6">
                    @include('question/_answered_questions_box')
                </div>
                <div class="col-md-6">
                    @include('question/_next_level_box')
                </div>
            </div>
            <!-- ./user metrics -->

            <!-- available-questions -->
            <div class="list-group">
                @forelse($questions as $question)
                    <a href="{{ $question->present()->publicUrl }}" class="list-group-item">
                        <h4 class="list-group-item-heading">{{ $question->name }}</h4>
                        <p class="list-group-item-text"></p>
                    </a>
                @empty
                    @include('question/_empty-list')
                @endforelse
            </div>
            <!-- ./available-questions -->

        </div>
        <!-- ./box-body -->

        <!-- pagination-links -->
        <div class="box-footer clearfix">
            {{ $questions->links('partials.simple-pager') }}
        </div>
        <!-- ./pagination-links -->
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="box box-danger">
                <div class="box-body">
                    <div class="jumbotron">
                        <h1>Challenge #1</h1>
                        <p>How much do you know about <strong>Houston</strong>?</p>
                        <p><a class="btn btn-primary btn-lg" href="https://thegame.mpi-internal.com/questions/challenge-houston-are-you-ready" role="button">Let's go!</a></p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="box box-danger">
                <div class="box-body">
                    <div class="jumbotron">
                        <h1>Challenge #2</h1>
                        <p>What's <strong>YAMS</strong>? Test yourself!</p>
                        <p><a class="btn btn-primary btn-lg" href="https://thegame.mpi-internal.com/questions/challenge-the-beginning" role="button">I'm in!</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
@endsection
