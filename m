Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5AA3FE5B
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Apr 2024 08:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714464213; cv=none; b=BeW1EDDwVXL4XpVHxYwzUzFDfVs6HPeJsno2mCvLDcvvBkTreBhauFVwRayBrT3EhKEijk1THBsjB3vz2dkmmSiNrh1vaOco2FAzElChb08ypMu1a8rsF6k/w6nnFEWNUD9O7f4xP0DNFuEOyI0SZvgbupQpVla0klwjhRJ+xN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714464213; c=relaxed/simple;
	bh=ZNTuTSyiV2VR6DQLKxG+UYMEOPlSKcG472CjlTBOu9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=GID2ITZxAE59lsJD78ILhi98/bj/9c3gsUGH2SWc/zLJ3+OsStT/JsXBInmIf00Rbl9G8qkHfTm2S/nwIGfK+dgxp7MRHnFHmTraJCCVegAKgbp+PawIXwWCqZxiiQsRhtNmiAM60dnFDOC5UQqiRArAimwcHe4Se6L8wP9HT/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qPtrOWIM; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qPtrOWIM"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e8fcb0b860so105425ad.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Apr 2024 01:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714464210; x=1715069010; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8X5OFsVhYwzme6q0mICzokiHa25Cg1yaJDJRvB1zZl8=;
        b=qPtrOWIM13FuN1tOGNQP2Kq9UvoL8PKS6ybyJSrwk1vj728AKY0GMWIaJaV7kUWlR9
         46VzSNSiJYPSuAk7yH9wxPtgTxgkkL3Ta8p/wToLRjB081U71NGxnWIxisN0H0ETf7jU
         LWt0vEFmiXKSgk8M33az8TvaWjIeQ4Lg1k1ZkBEuAqItUfPB2k1UIvMQYdC+QI7jwaTE
         BkyLjbi34wIbPJ0TGmTDWiO4IrnTZfGU7Hc0CQYDCPFU6kAzGYBQSDAFR1SGyIzmC3xX
         0Zc7YrSyEaun4NpGp0TIzdKkbmPVfmzd8j8yfY77WXfKjhR6JW8TAhPJ2pCyRar6wjIM
         ozbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714464210; x=1715069010;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8X5OFsVhYwzme6q0mICzokiHa25Cg1yaJDJRvB1zZl8=;
        b=cz57SkktEcrdwNe292qiKgKO7jR+hryqolP+YMfhDOoDE+23EnsoJuVLvhIIpjYyq2
         IIwhhT5hcPunjJlrXDHlRsNFHx2TgxlCHMj1xIMdnD2loVbcm+ZUDgPlOM0cYcJWpJSl
         PJkLOfXhpWADXAs/WayWjc4lk4Sr5JWXVGnKfi1XMjE1oXwI6EPQvkPuIuitkd1gRbNN
         +u4oW9YxrwvbdRMT9sMuiFvQqRNB4N86lVt/3RUV4H5OFzixnFmOO6qzBt7Xm2u2KIzg
         3eeQoE8azqpfSuNMwrBxOZszav46XDxsIy4wISo896VNNv6d4MzA0EJ5bcrAeJQzM4hp
         qwpg==
X-Gm-Message-State: AOJu0YznW7Oim5EQqIOTOH50aMKpDb9NJAtbZWFLJStQtA/IXJZGf/iX
	v3nMD3fGXFVNC9s/otdL10C2dqxDMoIB04OtPavvjdQ2K0dSSSIWyyT1W4shDvoarmAC29TEVPY
	9K6b1NRcRmTdyrrShS68ThtP9DDb8ZbnDRwjtV0FWaClYtA3/A7WCLOM=
X-Google-Smtp-Source: AGHT+IFjIZ/91irio7QcWXPR8fGucWuNFvbq38odr9c3R3IXSEtUrJC7qxUwbPKx6MOHzmeOej6yzG8mJK3PFgWw2oA=
X-Received: by 2002:a17:902:ce8a:b0:1e2:573:eecd with SMTP id
 f10-20020a170902ce8a00b001e20573eecdmr143842plg.3.1714464209709; Tue, 30 Apr
 2024 01:03:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430073908.1706482-1-irogers@google.com>
In-Reply-To: <20240430073908.1706482-1-irogers@google.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 30 Apr 2024 01:03:15 -0700
Message-ID: <CAP-5=fWQOB5QcrQ2rst0uq-B2A0BtNzSatFdtqG8+4Ba80G8MQ@mail.gmail.com>
Subject: Re: [PATCH v1] libtraceevent: Fix event-parse memory leak in process_cond
To: linux-trace-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 2024 at 12:39=E2=80=AFAM Ian Rogers <irogers@google.com> wr=
ote:
>
> Leak sanitizer was reporting a stack trace with perf:
> ```
> $ perf stat -e 'kvm:kvm_inj_exception' true
>
>  Performance counter stats for 'true':
>
>                  0      kvm:kvm_inj_exception
>
>        0.001701473 seconds time elapsed
>
>        0.000000000 seconds user
>        0.001865000 seconds sys
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D1705137=3D=3DERROR: LeakSanitizer: detected memory leaks
>
> Direct leak of 2 byte(s) in 1 object(s) allocated from:
>     #0 0x7f413ee80778 in __interceptor_strdup ../../../../src/libsanitize=
r/asan/asan_interceptors.cpp:454
>     #1 0x7f413ecb7b66 in __read_token libtraceevent/src/event-parse.c:127=
4
>     #2 0x7f413ecb85bb in read_token libtraceevent/src/event-parse.c:1432
>     #3 0x7f413ecbeaaa in process_entry libtraceevent/src/event-parse.c:25=
54
>     #4 0x7f413ecc54ae in process_arg_token libtraceevent/src/event-parse.=
c:3698
>     #5 0x7f413ecbb52e in process_arg libtraceevent/src/event-parse.c:2017
>     #6 0x7f413ecbd05a in process_op libtraceevent/src/event-parse.c:2357
>     #7 0x7f413ecc5a56 in process_arg_token libtraceevent/src/event-parse.=
c:3752
>     #8 0x7f413ecbb52e in process_arg libtraceevent/src/event-parse.c:2017
>     #9 0x7f413ecc5dd6 in event_read_print_args libtraceevent/src/event-pa=
rse.c:3791
>     #10 0x7f413ecc6511 in event_read_print libtraceevent/src/event-parse.=
c:3879
>     #11 0x7f413ecda16c in parse_format libtraceevent/src/event-parse.c:78=
08
>     #12 0x7f413ecda667 in __parse_event libtraceevent/src/event-parse.c:7=
866
>     #13 0x7f413ecda71b in tep_parse_format libtraceevent/src/event-parse.=
c:7908
>     #14 0x561672439029 in tp_format util/trace-event.c:94
>     #15 0x561672439141 in trace_event__tp_format util/trace-event.c:109
>     #16 0x56167230a429 in evsel__newtp_idx util/evsel.c:472
>     #17 0x561672329f99 in add_tracepoint util/parse-events.c:552
>     #18 0x56167232a5b4 in add_tracepoint_event util/parse-events.c:627
>     #19 0x56167232ebf2 in parse_events_add_tracepoint util/parse-events.c=
:1313
>     #20 0x561672411e0e in parse_events_parse util/parse-events.y:500
>     #21 0x561672332409 in parse_events__scanner util/parse-events.c:1878
>     #22 0x561672333cd4 in __parse_events util/parse-events.c:2146
>     #23 0x561672334e74 in parse_events_option util/parse-events.c:2349
>     #24 0x56167269ec23 in get_value tools/lib/subcmd/parse-options.c:251
>     #25 0x56167269fe65 in parse_short_opt tools/lib/subcmd/parse-options.=
c:351
>     #26 0x5616726a0e4d in parse_options_step tools/lib/subcmd/parse-optio=
ns.c:539
>     #27 0x5616726a1d86 in parse_options_subcommand tools/lib/subcmd/parse=
-options.c:654
>     #28 0x5616720e6ad2 in cmd_stat tools/perf/builtin-stat.c:2531
>     #29 0x5616722b0f5d in run_builtin tools/perf/perf.c:350
> $ cat /sys/kernel/tracing/events/kvm/kvm_inj_exception/format
> name: kvm_inj_exception
> ID: 1956
> format:
>         field:unsigned short common_type;       offset:0;       size:2; s=
igned:0;
>         field:unsigned char common_flags;       offset:2;       size:1; s=
igned:0;
>         field:unsigned char common_preempt_count;       offset:3;       s=
ize:1; signed:0;
>         field:int common_pid;   offset:4;       size:4; signed:1;
>
>         field:u8 exception;     offset:8;       size:1; signed:0;
>         field:u8 has_error;     offset:9;       size:1; signed:0;
>         field:u32 error_code;   offset:12;      size:4; signed:0;
>         field:bool reinjected;  offset:16;      size:1; signed:0;
>
> print fmt: "%s%s%s%s%s", __print_symbolic(REC->exception, { 0, "#" "DE" }=
, { 1, "#" "DB" }, { 3, "#" "BP" }, { 4, "#" "OF" }, { 5, "#" "BR" }, { 6, =
"#" "UD" }, { 7, "#" "NM" }, { 8, "#" "DF" }, { 10, "#" "TS" }, { 11, "#" "=
NP" }, { 12, "#" "SS" }, { 13, "#" "GP" }, { 14, "#" "PF" }, { 16, "#" "MF"=
 }, { 17, "#" "AC" }, { 18, "#" "MC" }), !REC->has_error ? "" : " (", !REC-=
>has_error ? "" : __print_symbolic(REC->error_code, { }), !REC->has_error ?=
 "" : ")", REC->reinjected ? " [reinjected]" : ""
> ```

Some more context. The place in the input where the leak appears is of
a string "?" read as a token at:
? "" : __print_symbolic(REC->error_code, { }), !REC->has_error ? "" :
")", REC->reinjected ? " [reinjected]" : ""

Laboriously debugged using printf. My belief that errors should clean
up allocations comes from:
https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/tree/src/eve=
nt-parse.c#n3754

The error comes from:
https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/tree/src/eve=
nt-parse.c#n2082
and that error originally comes from:
https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/tree/src/eve=
nt-parse.c#n2332
where the bad token in "}". The stack trace is:

#0  process_op (event=3D0x6080000003a0, arg=3D0x604000000ed0,
tok=3D0x7ffff2a01920) at event-parse.c:2333
#1  0x00007ffff5efba81 in process_arg_token (event=3D0x6080000003a0,
arg=3D0x604000000ed0,
   tok=3D0x7ffff2912360, type=3DTEP_EVENT_OP) at event-parse.c:3754
#2  0x00007ffff5ef152f in process_arg (event=3D0x6080000003a0,
arg=3D0x604000000ed0,
   tok=3D0x7ffff2912360) at event-parse.c:2017
#3  0x00007ffff5ef6fdb in process_fields (event=3D0x6080000003a0,
list=3D0x604000000e68,
   tok=3D0x7ffff29122a0) at event-parse.c:2939
#4  0x00007ffff5ef7c0a in process_symbols (event=3D0x6080000003a0,
arg=3D0x604000000e50,
   tok=3D0x7ffff2a01820) at event-parse.c:3076
#5  0x00007ffff5efaebd in process_function (event=3D0x6080000003a0,
arg=3D0x604000000e50,
   token=3D0x603000001840 "\270\002", tok=3D0x7ffff2a01820) at event-parse.=
c:3626
#6  0x00007ffff5efb631 in process_arg_token (event=3D0x6080000003a0,
arg=3D0x604000000e50,
   tok=3D0x7ffff29121e0, type=3DTEP_EVENT_DELIM) at event-parse.c:3715
#7  0x00007ffff5ef152f in process_arg (event=3D0x6080000003a0,
arg=3D0x604000000e50,
   tok=3D0x7ffff29121e0) at event-parse.c:2017
#8  0x00007ffff5ef19c5 in process_cond (event=3D0x6080000003a0,
top=3D0x604000000cd0,
   tok=3D0x7ffff2a016a0) at event-parse.c:2082
#9  0x00007ffff5ef3364 in process_op (event=3D0x6080000003a0,
arg=3D0x604000000cd0, tok=3D0x7ffff2a016a0)
   at event-parse.c:2375
#10 0x00007ffff5ef44e1 in process_op (event=3D0x6080000003a0,
arg=3D0x604000000cd0, tok=3D0x7ffff2a016a0)
   at event-parse.c:2500
#11 0x00007ffff5efba81 in process_arg_token (event=3D0x6080000003a0,
arg=3D0x604000000cd0,
   tok=3D0x7ffff2910e20, type=3DTEP_EVENT_OP) at event-parse.c:3754
#12 0x00007ffff5ef152f in process_arg (event=3D0x6080000003a0,
arg=3D0x604000000cd0,
   tok=3D0x7ffff2910e20) at event-parse.c:2017
#13 0x00007ffff5efbe01 in event_read_print_args (event=3D0x6080000003a0,
list=3D0x604000000b10)
   at event-parse.c:3793
#14 0x00007ffff5efc53c in event_read_print (event=3D0x6080000003a0) at
event-parse.c:3881
#15 0x00007ffff5f10197 in parse_format (eventp=3D0x7ffff3008020,
tep=3D0x6120000004c0,
   buf=3D0x619000000a80 "name: kvm_inj_exception\nID:
1956\nformat:\n\tfield:unsigned short common_ty
pe;\toffset:0;\tsize:2;\tsigned:0;\n\tfield:unsigned char
common_flags;\toffset:2;\tsize:1;\tsigned:
0;\n\tfield:unsigned char common_preem"..., size=3D992, sys=3D0x60200000545=
0 "kvm")
   at event-parse.c:7810
#16 0x00007ffff5f10692 in __parse_event (tep=3D0x6120000004c0,
eventp=3D0x7ffff3008020,
   buf=3D0x619000000a80 "name: kvm_inj_exception\nID:
1956\nformat:\n\tfield:unsigned short common_ty
pe;\toffset:0;\tsize:2;\tsigned:0;\n\tfield:unsigned char
common_flags;\toffset:2;\tsize:1;\tsigned:
0;\n\tfield:unsigned char common_preem"..., size=3D992, sys=3D0x60200000545=
0 "kvm")
   at event-parse.c:7868
#17 0x00007ffff5f10746 in tep_parse_format (tep=3D0x6120000004c0,
eventp=3D0x7ffff3008020,
   buf=3D0x619000000a80 "name: kvm_inj_exception\nID:
1956\nformat:\n\tfield:unsigned short common_ty
pe;\toffset:0;\tsize:2;\tsigned:0;\n\tfield:unsigned char
common_flags;\toffset:2;\tsize:1;\tsigned:
0;\n\tfield:unsigned char common_preem"..., size=3D992, sys=3D0x60200000545=
0 "kvm")
   at event-parse.c:7910
#18 0x0000555555b1e02a in tp_format (sys=3D0x602000005450 "kvm",
   name=3D0x6030000013f0 "kvm_inj_exception") at util/trace-event.c:94

So I think the error is in the "{}" in
"__print_symbolic(REC->error_code, { })" but I'm just guessing.

Thanks,
Ian

> The issue appears to be that when process_cond returns an error,
> callers clear the variable holding the string but the string was never
> freed. This change adds the free when process_cond returns
> TEP_EVENT_ERROR.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  src/event-parse.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/src/event-parse.c b/src/event-parse.c
> index d607556..b6ae67e 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2373,6 +2373,8 @@ process_op(struct tep_event *event, struct tep_prin=
t_arg *arg, char **tok)
>
>                 /* it will set arg->op.right */
>                 type =3D process_cond(event, arg, tok);
> +               if (type =3D=3D TEP_EVENT_ERROR)
> +                       free(token);
>
>         } else if (strcmp(token, ">>") =3D=3D 0 ||
>                    strcmp(token, "<<") =3D=3D 0 ||
> --
> 2.44.0.769.g3c40516874-goog
>
