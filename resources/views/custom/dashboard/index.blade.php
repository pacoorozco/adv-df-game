@extends('layouts.master')

{{-- Web site Title --}}
@section('title', __('site.home'))

{{-- Content Header --}}
@section('header', __('site.home'))

{{-- Breadcrumbs --}}
@section('breadcrumbs')
    <li class="active">
        <i class="fa fa-dashboard"></i> {{ __('site.home') }}
    </li>
@endsection

@section('content')
    <div class="row">
        <div class="col-md-6">
            <!-- Carousel -->
        @include('dashboard._carousel')
        <!-- ./carousel -->

            <!-- Welcome -->
            <div class="box box-solid">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class="fa fa-rocket"></i> Welcome to the <strong>oktoDATAfest</strong> game</h3>
                </div>
                <div class="box-body">
                    <p>Once upon a time there were legendary offsites but one day, suddenly everywhere went dark, 
                        the streets were empty and the memories of these offsite fade away.</p>
                    <p>But not completely, a tribe with a lot, <strong>a lot of data</strong> made millions of 
                    queries, searched inside billions of images, used Image recognition to identify faster, ran
                    thousands of experiments, millions of clusters were spawned and millions of curated datasets 
                    were analysed to find the truth, that <strong>the legend was real</strong>.</p>
                    <p>So they decided on continuing this tradition and make our <strong>first OktoDATAfest</strong>.</p>
                    <p>Are you ready to test your knowledge about our tribe?</p>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- ./welcome -->

            <!-- Pending questions -->
            <div class="box box-solid">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class="fa fa-gamepad"></i> Play with us</h3>
                </div>
                <div class="box-body">
                    @include('dashboard._questions')
                </div>
            </div>
            <!-- ./pending questions -->

        </div>


        <div class="col-md-6">

            <!-- Ranking -->
            <div class="box box-solid">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class="fa fa-trophy"></i> Ranking</h3>
                </div>
                <div class="box-body">
                    @include('dashboard._ranking')
                </div>
            </div>
            <!-- ./ranking -->

        </div>
    </div>
@endsection
