%CLSversion 1.1.2
\ProvidesClass{nagwa}[2016/08/08]

%==========================Packages==========================

\RequirePackage{silence}
\WarningsOff*
\WarningFilter{tasks}{You've}
\WarningFilter{babel}{The following font families will use the default}
\WarningFilter{babel}{The current font is not a babel standard family}
\WarningFilter{latex}{Command \underbar}
\WarningFilter{latex}{Command \underline}
\WarningFilter{latex}{Font shape}
\WarningFilter{fontspec}{Font shape}
\WarningFilter{ocgx2}{Rerun to get}
\WarningFilter{rerunfilecheck}{File}
\WarningFilter{lastpage}{Rerun to get}

\RequirePackage{luatexbase}
\directlua{
function be_quiet (...)
    return true
end
luatexbase.add_to_callback('start_run', be_quiet, 'stop start run')
luatexbase.add_to_callback('stop_run', be_quiet, 'stop stop run')
luatexbase.add_to_callback('start_page_number', be_quiet, 'stop start page')
luatexbase.add_to_callback('stop_page_number', be_quiet, 'stop stop page')
luatexbase.add_to_callback('start_file', be_quiet, 'stop start file')
luatexbase.add_to_callback('stop_file', be_quiet, 'stop stop file')
luatexbase.add_to_callback('show_warning_message', be_quiet, 'stop show warning message')
}


\RequirePackage{kvoptions} % to allow adding key-pair options
\RequirePackage{pdfpages} % to include any PDF images
\RequirePackage{tikz} % our standard package for math environments
\RequirePackage{amsmath} % our standard package for math environments\typeout{Required packages loaded...}
\RequirePackage{xstring} % to check if parameter is number
\RequirePackage{ifthen}

% Dummy definition to satisfy packages loaded early, if absolutely necessary
\providecommand{\normalsize}{\fontsize{13.5pt}{1.5em}\selectfont}

\RequirePackage{diagbox}
\RequirePackage{colortbl}
\RequirePackage{arydshln}
\RequirePackage{chemformula}
\RequirePackage{slashbox}
\RequirePackage{pifont}
% \RequirePackage{ocgx2} % For handwriting layers
\RequirePackage{eso-pic} % For absolute positioning
\RequirePackage{xparse} % For command parsing

\RequirePackage{pgfmath}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18, compat/show suggested version=false}


\RequirePackage{varwidth} % For text width in nodes

\RequirePackage{tipa}  % Required for vowel sounds symbols

\RequirePackage{pdfrender} 
\RequirePackage{parskip}

\RequirePackage{newunicodechar} % Required to process the commands in Unicodes.tex
\input{Unicodes.tex}            % Loads the character definitions

\typeout{Packages loaded...}

%==========================Options==========================

\DeclareStringOption{country}{} 
\DeclareStringOption{nagwalang}{}
\DeclareStringOption{math}{}
\DeclareStringOption{numerals}{}
\DeclareStringOption{directions}{}
\DeclareStringOption{nagwagrade}{}
\DeclareStringOption{qrcmode}{}
\ProcessKeyvalOptions*\relax

\let\country=\nagwa@country
\typeout{ Your country \country}

\let\nagwalang=\nagwa@nagwalang
\typeout{ Your language \nagwalang}

\let\math=\nagwa@math
\typeout{ Your symbols language is \math}

\let\directions = \nagwa@directions
\typeout{ Your directions are in \directions}

\let\nagwagrade = \nagwa@nagwagrade
\typeout{ Your nagwagrade is \nagwagrade}

\let\numerals = \nagwa@numerals
\typeout{ Your numerals are in \numerals}

\let\qrcmode = \nagwa@qrcmode
\typeout{ Your mode are in \qrcmode}

\def\objecttype#1{\def\@objecttype{#1}}

\DeclareOption{Session_Slide}{\objecttype{Session_Slide}}
\DeclareOption{Book}{\objecttype{Book}}

\DeclareOption*{}{}
\DeclareMathOperator{\adj}{adj}						   
\ProcessOptions*\relax
\typeout{Options loaded...}



\definecolor{coverfuchia}{cmyk}{0.0, 0.94, 0.22, 0.0}
\definecolor{coverblue}{cmyk}{0.91, 0.5, 0.03, 0.0}
\definecolor{coverblack}{cmyk}{0.0, 0.0, 0.0, 1.0}

% Define named colors for handwriting
\definecolor{hwBlack}{HTML}{4D4D4F}
\definecolor{hwBlue}{HTML}{56A5E1}
\definecolor{hwRed}{HTML}{E24C3C}
\definecolor{hwGreen}{HTML}{119F25}
\definecolor{hwOrange}{HTML}{F4A304}
\definecolor{hwPurple}{HTML}{FF2AFF}


%% Bright Colours
\definecolor{Grey}{RGB}{76,76,78}
\definecolor{Blue}{RGB}{85,164,224}
\definecolor{Red}{RGB}{225,75,59}
\definecolor{Green}{RGB}{16,158,36}
\definecolor{Orange}{RGB}{243,162,3}
\definecolor{Purple}{RGB}{124,36,231}
\definecolor{Fuchsia}{RGB}{225,50,162}
\definecolor{Pink}{RGB}{225,50,162}
\definecolor{Brown}{RGB}{138,93,59}

%% Light Colours
\definecolor{LightGrey}{RGB}{130,130,131}
\definecolor{LightBlue}{RGB}{98,170,223}
\definecolor{LightRed}{RGB}{236,98,88}
\definecolor{LightGreen}{RGB}{105,186,108}
\definecolor{LightOrange}{RGB}{251,192,79}
\definecolor{LightPurple}{RGB}{160,114,235}
\definecolor{LightFuchsia}{RGB}{237,97,174}

%% extra colours
\definecolor{NagwaGreen}{RGB}{120,181,23}
\definecolor{NagwaBlue}{RGB}{0,108,182}
\definecolor{NagwaGrey}{RGB}{214,214,216}
\definecolor{darkRed}{RGB}{163,21,21}


%% Table Colours
\definecolor{TableBackgroundColor}{RGB}{254,250,244}
\definecolor{TableBorderColor}{RGB}{249,215,162}
\definecolor{TableTextColor}{RGB}{208,140,34}

%% Bars Colours
\definecolor{LightBlueBar}{HTML}{1483c2}
\definecolor{DarkBlueBar}{HTML}{005a7f}

%% Title and Thank you Colours
\definecolor{lightGrey}{RGB}{147,147,147}
\definecolor{darkGrey}{RGB}{86,87,89}
\definecolor{TitleLightBlue}{HTML}{dae9f4}

\definecolor{TitlePageBlue}{RGB}{0,115,181}

\definecolor{PaleSkyBlue}{RGB}{201, 218, 248}

%==========================Inputs==========================
\input{DocumentClass}



\makeatletter
\AtBeginDocument{%  
  % Prime chemformula to initialize PGF shapes (fixed No shape named chemformula-bond-end' is known)
  \setbox0=\hbox{\ch{A-B=C <-> E}}
\renewcommand\diagbox@double@pict@SE{%
\put(0,0) {\makebox(0,0)[bl]{\box\diagbox@boxa}}
\put(\strip@pt\diagbox@wd,\strip@pt\diagbox@ht) {\makebox(0,0)[tr]{\box\diagbox@boxb}}
\Line(0,\strip@pt\diagbox@ht)(\strip@pt\diagbox@wd,0)}
\let\diagbox@double@pict@NW\diagbox@double@pict@SE
\renewcommand\diagbox@double@pict@NE{%
\put(0,0) {\makebox(0,0)[bl]{\box\diagbox@boxa}} 
\put(\strip@pt\diagbox@wd,\strip@pt\diagbox@ht) {\makebox(0,0)[tr]{\box\diagbox@boxb}} 
\Line(0,\strip@pt\diagbox@ht)(-\strip@pt\diagbox@wd,0)}
\let\diagbox@double@pict@SW\diagbox@double@pict@NE


\newfontfamily\arabicfont[Script=Arabic, BoldFont={Noto-Bold.ttf}]{Noto-Regular.ttf}

\newcommand\ARtextrm[1]{%
\directlua{tex.enableprimitives('', tex.extraprimitives())}%
\textrm{\textdir TRT \arabicfont #1}}

\newfontfamily\englishfont{STIX2Text-Regular.otf}[
        BoldFont = STIX2Text-Bold.otf ,
        ItalicFont = STIX2Text-Italic.otf ,
        BoldItalicFont = STIX2Text-BoldItalic.otf]
       
\newcommand{\ENtextrm}[1] % English inside TRT
        {\bgroup\textdir TLT\englishfont #1\egroup}


\ifthenelse{\equal{\nagwalang}{ar}}{
    \let\oldch\ch % chem inside TRT
    % \renewcommand{\ch}[1]{\ENtextrm{\oldch{#1}}}
    \renewcommand{\ch}[1]{\mbox{\ENtextrm{\oldch{#1}}}}
  }{}
}
\makeatother

% font style and size

\everymath{\displaystyle}%

\directlua{
luatexbase.add_to_callback("show_error_hook", function ()
texio.write_nl("[" .. status.filename .. ": " .. status.linenumber .. "]")
if (status.lasterrorcontext) then texio.write_nl(status.lasterrorcontext) end
texio.write_nl("ERROR_END")
end, "show_error_hook")
}

\setchemformula{
    bond-length = 4mm,
    plus-space = 0.2em,
    arrow-style = {line width=1.2pt}
}

\usetikzlibrary{arrows.meta}
\RenewChemArrow{->}{
    \draw[chemarrow, -{Stealth[round,width=1.5mm,scale=1.55]}] (cf_arrow_start) -- (cf_arrow_end);
}



\ExplSyntaxOn

\cs_set_protected:Npn \__chemformula_parse_stoich:w \s_stop #1 \q_nil
  {
    \__chemformula_bool_set_if_first_last:Nnnn
      \l__chemformula_stoich_is_iupac_bool {#1} { ( } { ) }
    \bool_if:NTF \l__chemformula_stoich_is_iupac_bool
      { \__chemformula_parse_stoich_iupac:n {#1} }
      { \__chemformula_parse_stoich_regular:n {#1} }
    }

\cs_set_protected:Npn \__chemformula_input_stoich:n #1
  {
    \bool_set_true:N \l__chemformula_stoich_bool
    % the factor consists only of a parenthesis or a decimal marcer:
    \bool_set_true:N \l__chemformula_no_stoich_bool
    \tl_map_inline:nn {#1}
      {
        \prop_if_in:NnF \l__chemformula_no_stoich_prop {##1}
          {
            \bool_set_false:N \l__chemformula_no_stoich_bool
            \tl_map_break:
          }
      }
    \bool_if:NF \l__chemformula_no_stoich_bool
      {
        \tl_map_inline:nn {#1}
          {
            \prop_get:NnNTF \l__chemformula_stoich_prop {##1} \l__chemformula_tmpa_tl
              {
                \bool_if:NT \l__chemformula_stoich_bool
                  { \tl_put_right:NV \l__chemformula_stoich_tl \l__chemformula_tmpa_tl }
              }
              {
                \bool_set_false:N \l__chemformula_stoich_bool
                \tl_map_break:
              }
           }
      }
    \bool_if:NTF \l__chemformula_stoich_bool
      {
        \tl_if_blank:VF \l__chemformula_stoich_tl
          {
            \tl_put_left:Nn \l__chemformula_stoich_tl { \s_stop } % <-- \q_mark changed to \s_stop
            \__chemformula_sanitize:NV
              \l__chemformula_stoich_tl
              \l__chemformula_stoich_tl
            \chemformula_print_stoich:V
              \l__chemformula_stoich_tl
          }
      }
      { \tl_clear:N \l__chemformula_stoich_tl }
  }

\ExplSyntaxOff

% ==========================================
% Unbreakable environments: tasks, itemize, enumerate
% ==========================================
\newbox\nagwapagebreakbox
\newcount\nagwapagebreakdepth

\newcommand{\nagwabeforeunbreak}{%
  \ifnum\nagwapagebreakdepth=0\relax
    \setbox\nagwapagebreakbox=\vtop\bgroup
  \fi
  \global\advance\nagwapagebreakdepth by 1\relax
}

\newcommand{\nagwaafterunbreak}{%
  \global\advance\nagwapagebreakdepth by -1\relax
  \ifnum\nagwapagebreakdepth=0\relax
    \egroup
    \nagwaoutputunbreakbox
  \fi
}

\newcommand{\nagwaoutputunbreakbox}{%
  \dimen0=\dimexpr\ht\nagwapagebreakbox+\dp\nagwapagebreakbox\relax
  \ifdim\dimen0>\textheight
    \unvbox\nagwapagebreakbox
  \else
    \ifdim\dimexpr\pagetotal+\dimen0\relax>\textheight
      \newpage
    \fi
    \box\nagwapagebreakbox
  \fi
}

\NewEnvironmentCopy{origtasks}{tasks}
\ExplSyntaxOn
\dim_new:N \l__nagwa_max_task_width_dim
\dim_new:N \l__nagwa_threshold_dim
\seq_new:N \l__nagwa_tasks_seq
\box_new:N \l__nagwa_task_box
\tl_new:N  \l__nagwa_cols_tl

\RenewDocumentEnvironment{tasks}{ o d() +b }
  {
    \IfValueTF { #2 }
      {
        \tl_set:Nn \l__nagwa_cols_tl { #2 }
      }
      {
        \dim_set:Nn \l__nagwa_threshold_dim { ( \pagewidth - \nagwaLmargin - \nagwaRmargin - 100pt ) / 2 }
        \dim_zero:N \l__nagwa_max_task_width_dim

        \seq_set_split:Nnn \l__nagwa_tasks_seq { \task } { #3 }

        \seq_map_inline:Nn \l__nagwa_tasks_seq
          {
            \tl_if_blank:nF { ##1 }
              {
                \hbox_set:Nn \l__nagwa_task_box { \let\par\space \ignorespaces ##1 \unskip }
                \dim_set:Nn \l__nagwa_max_task_width_dim
                  {
                    \dim_max:nn { \l__nagwa_max_task_width_dim } { \box_wd:N \l__nagwa_task_box }
                  }
              }
          }

        \dim_compare:nNnTF { \l__nagwa_max_task_width_dim } < { \l__nagwa_threshold_dim }
          { \tl_set:Nn \l__nagwa_cols_tl { 2 } } 
          { \tl_set:Nn \l__nagwa_cols_tl { 1 } } 
      }

    \int_compare:nNnTF { \nagwapagebreakdepth } > { 0 }
    {
      \use:e
        {
          \IfValueTF { #1 }
            { \exp_not:N \begin{origtasks} [ \exp_not:n { #1 } ] ( \l__nagwa_cols_tl ) }
            { \exp_not:N \begin{origtasks} ( \l__nagwa_cols_tl ) }
          \exp_not:n { #3 }
          \exp_not:N \end{origtasks}
        }
    }
    {
      \int_gincr:N \nagwapagebreakdepth
      
      \vbox_gset_top:Nn \nagwapagebreakbox
        {
          \use:e
            {
              \IfValueTF { #1 }
                { \exp_not:N \begin{origtasks} [ \exp_not:n { #1 } ] ( \l__nagwa_cols_tl ) }
                { \exp_not:N \begin{origtasks} ( \l__nagwa_cols_tl ) }
              \exp_not:n { #3 }
              \exp_not:N \end{origtasks}
            }
        }
      \int_gdecr:N \nagwapagebreakdepth
      \nagwaoutputunbreakbox
    }
  }
  {
  }
\ExplSyntaxOff

\ifthenelse{\equal{\@objecttype}{Book}}{
  \BeforeBeginEnvironment{itemize}{\nagwabeforeunbreak}
  \AfterEndEnvironment{itemize}{\nagwaafterunbreak}
  \BeforeBeginEnvironment{enumerate}{\nagwabeforeunbreak}
  \AfterEndEnvironment{enumerate}{\nagwaafterunbreak}
}{}


% \setlist[itemize,1]{label=\textbullet, leftmargin=43bp, topsep=0pt, itemsep=0pt}
% \setlist[itemize,2]{label=\textendash, leftmargin=35bp, topsep=0pt, itemsep=0pt}
% \setlist[itemize,3]{label=$\ast$, leftmargin=27bp, topsep=0pt, itemsep=0pt}


\newcommand{\warningsign}{\tikz[baseline=-.70ex]{\node[shape=regular polygon, regular polygon sides=3, inner sep=0pt, draw, thick] {\textbf{!}};}}
\newcommand{\circled}[1]{\tikz[baseline=(char.base)]{\node[shape=ellipse,draw,inner sep=2pt] (char) {#1};}}
\newcommand{\slidevrule}[1]{\hfill\parbox{5pt}{\textcolor{NagwaBlue}{\rule{1pt}{#1}}}\hfill}
\newcommand{\Bigcircle}{\raisebox{-0.5mm}{\scalebox{2.7}{$\bigcirc$}}}
\newcommand{\fillrel}{\mathrel{\scalebox{1.7}{\fbox{$\phantom{\bigcirc}$}}}}


\newcommand*{\shortblank}{\rule{3em}{1pt}}
\newcommand*{\mediumblank}{\rule{5em}{1pt}}
\newcommand*{\longblank}{\rule{8em}{1pt}}


\renewcommand{\arraystretch}{1.4}

\fancyfoot[C]{}
\fancyhead[C]{}

