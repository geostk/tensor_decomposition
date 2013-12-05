%% data loading
clear;clc;close all;
addpath('./lib/nway331/');            % PARAFAC
addpath('./lib/vis/export_fig/');     % export_fig
load ./data/data.mat;

%% parafac 

% please uncomment the following line to manually run 
% decomp_parafac_num.m

% core script for parafac decomposition of each chemical's tensor data
decomp_parafac;

%  the decomposition result could be visually examed by the following
%  script
% decomp_parafac_test

%%
fig_parafac;