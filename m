Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0EB5685;
	Thu,  9 Nov 2023 04:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67F626A2;
	Wed,  8 Nov 2023 20:49:02 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6b89ab5ddb7so441829b3a.0;
        Wed, 08 Nov 2023 20:49:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699505342; x=1700110142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//fNZW24HiQXJZnbOmMOKxa5B9sCqJvB/Cm0s9I+HRc=;
        b=FyrE4iipUD6QqWr/bnLXucq7Wk9zFxszNIAt7uFH5vU2zCXSIEDN3UybuV2ohRbmFJ
         diU02RGT9FhhBSHDYWZ3NI6U6evN/OCNOYDYMmmeVFQMcvxpnQluELiF0nhOIijZFVmw
         WCtkudrJE4ipwNw+gDAXfTBU0xH7iepkmq4S5lbz4wyHHMUmwk80tcuIp4m78dn5ufXr
         nFR77jCq021GwtvnDzNiKWgQueeu8fshDPRlYVqKQYbG3KbqscFO8pGr2K1Fg0JhFpoj
         VYH55mrBCVDE5N7hTwLfuH4TnGbJ6mhGfHAnFyoxFk8uGnr20WxGYZjWn30k+vLTrcyH
         SCEw==
X-Gm-Message-State: AOJu0YyCwwBSfX1X4cRQMFXAH0HGvtaaObcQnaC6DpP/GFJNZnlJ6jEo
	ntrK2sjk73zAoICGrtfUC21W/2I7qzvEcOH493I=
X-Google-Smtp-Source: AGHT+IGM/Yu0tNAUEG9TLLx7rAmF6coIAA82p+3BHh2r/DRVp1V3HED5aMHwQATgWAsvAkW4rj58aM+DZmkAHfFxe8w=
X-Received: by 2002:a05:6a20:a121:b0:17b:7505:8ab7 with SMTP id
 q33-20020a056a20a12100b0017b75058ab7mr4524066pzk.46.1699505342069; Wed, 08
 Nov 2023 20:49:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <82cd8b7e-bd46-49ed-9160-eabcfd4c3c20@redhat.com>
In-Reply-To: <82cd8b7e-bd46-49ed-9160-eabcfd4c3c20@redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 8 Nov 2023 20:48:50 -0800
Message-ID: <CAM9d7ciWY6kvVB-JkrJS7BZs_WMy-OZRgwLvBG9WQ-Zi00czfA@mail.gmail.com>
Subject: Re: [RFC 00/48] perf tools: Introduce data type profiling (v1)
To: Joe Mario <jmario@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org, Ben Woodard <woodard@redhat.com>, 
	Kees Cook <keescook@chromium.org>, David Blaikie <blaikie@google.com>, Xu Liu <xliuprof@google.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Ravi Bangoria <ravi.bangoria@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Nov 8, 2023 at 9:12=E2=80=AFAM Joe Mario <jmario@redhat.com> wrote:
>
> Hi Namhyung:
>
> I've been playing with your datatype profile patch and it looks really pr=
omising.
> I think it would be a big help if it could be integrated into perf c2c.

Great!  Yeah, I think we can collaborate on it.

>
> Perf c2c gives a great insight into what's contributing to cpu cacheline =
contention, but it
> can be difficult to understand the output.  Having visuals with your data=
type profile output
> would be a big help.

Exactly.

>
> I have a simple test program with readers and writers tugging on the data=
 below:
>
>   uint64_t hotVar;
>   typedef struct __foo {
>      uint64_t m1;
>      uint64_t m2;
>      uint64_t m3;
>   } FOO;
>
> The rest of this reply looks at both your datatype output and c2c to see =
where they
> might compliment each other.
>
>
> When I run perf with your patches on a simple program to cause contention=
 on the above data, I get the following:
>
> # perf mem record --ldlat=3D1 --all-user --  ./tugtest -r3 -r5 -r7 -r9 -r=
11 -w10 -w12 -w14 -w16 -b5 -H2000000
> # perf report -s type,typeoff --hierarchy --stdio
>
>    # Samples: 26K of event 'cpu/mem-loads,ldlat=3D1/P'
>    # Event count (approx.): 2958226
>    #
>    #    Overhead  Data Type / Data Type Offset
>    # ...........  ............................
>    #
>        54.50%     int
>           54.50%     int +0 (no field)
>        23.21%     long int
>           23.21%     long int +0 (no field)
>        18.30%     struct __foo
>            9.57%     struct __foo +8 (m2)
>            8.73%     struct __foo +0 (m1)
>         3.86%     long unsigned int
>            3.86%     long unsigned int +0 (no field)
>        <snip>
>
>    # Samples: 30K of event 'cpu/mem-stores/P'
>    # Event count (approx.): 33880197
>    #
>    #    Overhead  Data Type / Data Type Offset
>    # ...........  ............................
>    #
>        99.85%     struct __foo
>           70.48%     struct __foo +0 (m1)
>           29.34%     struct __foo +16 (m3)
>            0.03%     struct __foo +8 (m2)
>         0.09%     long unsigned int
>            0.09%     long unsigned int +0 (no field)
>         0.06%     (unknown)
>            0.06%     (unknown) +0 (no field)
>        <snip>
>
> Then I run perf annotate with your patches, and I get the following:
>
>   # perf annotate  --data-type
>
>    Annotate type: 'long int' in /home/joe/tugtest/tugtest (2901 samples):
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>        samples     offset       size  field
>           2901          0          8  long int  ;
>
>    Annotate type: 'struct __foo' in /home/joe/tugtest/tugtest (5593 sampl=
es):
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>        samples     offset       size  field
>           5593          0         24  struct __foo       {
>           2755          0          8      uint64_t      m1;
>           2838          8          8      uint64_t      m2;
>              0         16          8      uint64_t      m3;
>                                       };
>
> Now when I run that same simple test using perf c2c, and I focus on the c=
achline that the struct and hotVar reside in, I get:
>
> # perf c2c record --all-user -- ./tugtest -r3 -r5 -r7 -r9 -r11 -w10 -w12 =
-w14 -w16 -b5 -H2000000
> # perf c2c report -NNN --stdio
> # <snip>
> #
> #      ----- HITM -----  ------- Store Refs ------  ------ Data address -=
-----                ---------- cycles ----------    Total    cpu          =
     Shared
> # Num  RmtHitm  LclHitm   L1 Hit  L1 Miss      N/A        Offset  Node  P=
A cnt  Code address  rmt hitm  lcl hitm      load  records    cnt      Symb=
ol   Object    Source:Line  Node{cpu list}
> #....  .......  .......  .......  .......  .......  ............  ....  .=
.....  ............  ........  ........  ........  .......  .....  ........=
..  .......  .............  ....
> #
>  ---------------------------------------------------------------
>     0     1094     2008    17071    13762        0      0x406100
>  ---------------------------------------------------------------
>          0.00%    0.20%    0.00%    0.00%    0.00%           0x8     1   =
    1      0x401355         0       978      1020     2962      4  [.] writ=
er  tugtest  tugtest.c:129   0{10,12,14,16}
>          0.00%    0.00%    0.12%    0.02%    0.00%           0x8     1   =
    1      0x401360         0         0         0       23      4  [.] writ=
er  tugtest  tugtest.c:129   0{10,12,14,16}
>         68.10%   60.26%    0.00%    0.00%    0.00%          0x10     1   =
    1      0x401505      2181      1541      1393     5813      5  [.] read=
er  tugtest  tugtest.c:163   1{3,5,7,9,11}
>         31.63%   39.34%    0.00%    0.00%    0.00%          0x10     1   =
    1      0x401331      1242      1095       936     3393      4  [.] writ=
er  tugtest  tugtest.c:127   0{10,12,14,16}
>          0.00%    0.00%   40.03%   40.25%    0.00%          0x10     1   =
    1      0x40133c         0         0         0    12372      4  [.] writ=
er  tugtest  tugtest.c:127   0{10,12,14,16}
>          0.27%    0.15%    0.00%    0.00%    0.00%          0x18     1   =
    1      0x401343       834      1136      1032     2930      4  [.] writ=
er  tugtest  tugtest.c:128   0{10,12,14,16}
>          0.00%    0.05%    0.00%    0.00%    0.00%          0x18     1   =
    1      0x40150c         0       933      1567     5050      5  [.] read=
er  tugtest  tugtest.c:163   1{3,5,7,9,11}
>          0.00%    0.00%    0.06%    0.00%    0.00%          0x18     1   =
    1      0x40134e         0         0         0       10      4  [.] writ=
er  tugtest  tugtest.c:128   0{10,12,14,16}
>          0.00%    0.00%   59.80%   59.73%    0.00%          0x20     1   =
    1      0x401516         0         0         0    18428      5  [.] read=
er  tugtest  tugtest.c:163   1{3,5,7,9,11}
>
> With the above c2c output, we can see:
>  - the hottest contended addresses, and the load latencies they caused.
>  - the cacheline offset for the contended addresses.
>  - the cpus and numa nodes where the accesses came from.
>  - the cacheline alignment for the data of interest.
>  - the number of cpus and threads concurrently accessing each address.
>  - the breakdown of reads causing HITM (contention) and writes hitting or=
 missing the cacheline.
>  - the object name, source line and line number for where the accesses oc=
cured.
>  - the numa node where the data is allocated.
>  - the number of physical pages the virtual addresses were mapped to (e.g=
. numa_balancing).
>
> What would really help the c2c output be more usable is if it had a bette=
r visual to it.
> It's likely the current c2c output can be trimmed a bit.
>
> Here's one idea that incorporates your datatype info, though I'm sure the=
re are better ways, as this may get unwieldy.:
>
> #      ----- HITM -----  ------- Store Refs ------  ------ Data address -=
-----                ---------- cycles ----------    Total    cpu          =
     Shared
> # Num  RmtHitm  LclHitm   L1 Hit  L1 Miss      N/A        Offset  Node  P=
A cnt  Code address  rmt hitm  lcl hitm      load  records    cnt      Symb=
ol   Object    Source:Line  Node{cpu list}
> #....  .......  .......  .......  .......  .......  ............  ....  .=
.....  ............  ........  ........  ........  .......  .....  ........=
..  .......  .............  ....
> #
>  ---------------------------------------------------------------
>     0     1094     2008    17071    13762        0      0x406100
>  ---------------------------------------------------------------
>   uint64_t hotVar: tugtest.c:38
>          0.00%    0.20%    0.00%    0.00%    0.00%           0x8     1   =
    1      0x401355         0       978      1020     2962      4  [.] writ=
er  tugtest  tugtest.c:129   0{10,12,14,16}
>          0.00%    0.00%    0.12%    0.02%    0.00%           0x8     1   =
    1      0x401360         0         0         0       23      4  [.] writ=
er  tugtest  tugtest.c:129   0{10,12,14,16}
>   struct __foo uint64_t m1: tugtest.c:39
>         68.10%   60.26%    0.00%    0.00%    0.00%          0x10     1   =
    1      0x401505      2181      1541      1393     5813      5  [.] read=
er  tugtest  tugtest.c:163   1{3,5,7,9,11}
>         31.63%   39.34%    0.00%    0.00%    0.00%          0x10     1   =
    1      0x401331      1242      1095       936     3393      4  [.] writ=
er  tugtest  tugtest.c:127   0{10,12,14,16}
>          0.00%    0.00%   40.03%   40.25%    0.00%          0x10     1   =
    1      0x40133c         0         0         0    12372      4  [.] writ=
er  tugtest  tugtest.c:127   0{10,12,14,16}
>   struct __foo uint64_t m2: tugtest.c:40
>          0.27%    0.15%    0.00%    0.00%    0.00%          0x18     1   =
    1      0x401343       834      1136      1032     2930      4  [.] writ=
er  tugtest  tugtest.c:128   0{10,12,14,16}
>          0.00%    0.05%    0.00%    0.00%    0.00%          0x18     1   =
    1      0x40150c         0       933      1567     5050      5  [.] read=
er  tugtest  tugtest.c:163   1{3,5,7,9,11}
>          0.00%    0.00%    0.06%    0.00%    0.00%          0x18     1   =
    1      0x40134e         0         0         0       10      4  [.] writ=
er  tugtest  tugtest.c:128   0{10,12,14,16}
>   struct __foo uint64_t m3: tugtest.c:41
>          0.00%    0.00%   59.80%   59.73%    0.00%          0x20     1   =
    1      0x401516         0         0         0    18428      5  [.] read=
er  tugtest  tugtest.c:163   1{3,5,7,9,11}
>
> And then it would be good to find a clean way to incorporate your sample =
counts.

I'm not sure we can get the exact source line for the data type/fields.
Of course, we can aggregate the results for each field.  Actually you
can use `perf report -s type,typeoff,symoff --hierarchy` for something
similar. :)

>
> On a related note, is there a way the accesses could be broken down into =
read counts
> and write counts?   That, with the above source line info for all the acc=
esses,
> helps to convey a picture of "the affinity of the accesses".

Sure, perf report already supports showing events in a group
together.  You can use --group option to force grouping
individual events.  perf annotate with --data-type doesn't have
that yet.  I'll update it in v2.

>
> For example, while it's normally good to separate read-mostly data from h=
ot
> written data, if the reads and writes are done together in the same block=
 of
> code by the same thread, then keeping the two data symbols in the same ca=
cheline
> could be a win.  I've seen this often. Your datatype info might be able t=
o
> make these affinities more visible to the user.
>
> Thanks for doing this. This is great.
> Joe

Thanks for your feedback!
Namhyung
