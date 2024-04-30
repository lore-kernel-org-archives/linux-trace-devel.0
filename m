Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32F211C
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Apr 2024 07:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714462764; cv=none; b=DmGDOXhFyqJX4p9etuHxi9fZTHf+mln0V30hl4/x5OJ8aM26h/GcACgNDO+NUjFpZbMqi+81oFWEt7AoKfZN83R/K8yF3Myq5SKTlBh3az/0gXfYjR0GdTpDScwL8WjvTPNBaRvbECgQ6hdcNAn0vn7y3/NJjio5+//ooG05Ff0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714462764; c=relaxed/simple;
	bh=URpvyP+rp/Z1zhw/Ltm6tfgJV6y/Y85sHSKqr6M7UIA=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=JnuqhcqKzEj9+2ZAI+6ChbiWGkaiRbUVLjdIZAoYkispBxq8IZBsAulwnmKrfKaGNfs1mbQDuu1/oMN+REfogPDmXqFhG9GGLMMNV2nEm/musvYF7a1L3Ie2S8wMn/0woPCKq0if4VLmjrWcmNsVhvmQWcB6hOANpvymnM+ifyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=goam4/o9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="goam4/o9"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de610854b8bso1489716276.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Apr 2024 00:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714462761; x=1715067561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ucNid5wpGd0HFftl4AzgXA7yVkxX5zh2ikQ7DqGAT00=;
        b=goam4/o9HbQ0EvDPevdif0+Aj21aAd39J+bleERG9bt5PLGzGIIXsceXse3ki1wu24
         PDuWfvEMdmR5mxF2p47MOIKcxcE6f6/6/dbUMFPC+Qv44Pyy563gfPNBVJKqY3VbpJWh
         HEEQY0m2omkuODjFi6XeiRr3Xu/mJuY2Ntn7xp2TxeCZ1YVNTqDdn3mS9n5tAAl3x83r
         dcKuZHt1uFEHaMwQRxFKNui8e8GX10GEyeUs0174QTiBWCwUnS6daIk1hopQ1bIAAIHe
         8e6OyvBpmc0vtt+/IQmHw1BdBF02FNk3ibQwilxNJBXH8mzgBZym06ek/da3sCuA11YG
         m/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714462761; x=1715067561;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ucNid5wpGd0HFftl4AzgXA7yVkxX5zh2ikQ7DqGAT00=;
        b=wnwcwae4x7mVa2yRceakAxW6hicAGvrMvaPrizNRHVMvEvkVtvs+ikiOhGT2xD6K8s
         y+aYf2WEuTCKGFla63sahTTZgTdzvKXn9LCaIMgvDLhDvfvfcJ3R/K7+ndMV7PQp5Nps
         nDm21rdPh1nrjupe0LpBY4+6xSBbUxT5mc/ZWZRpNdp1UwufxYwCeH1b4kr5WkRO20tw
         2FvqwOBSW71klE0jMpob/92EWO/ScEYOHYj5tfd70TAUcNj2e2tW+hqsOcuZEosRUFf5
         NsS/mvfSx6e0+l4mfjIIDnmOKQJR5v1B5YjaO8r2wVZllxmSTjCxmm4QZCBc+3g0G3U1
         L9xQ==
X-Gm-Message-State: AOJu0YwuoteRS83OT574A46HTaD3GMLrjz90P1Lco0MSRmspoqrUFHVx
	2PA7EFtlo/6xIMqwwStJ9gMY49VXdAn33yeYRPkemqd+IJBT2ORWOOHuLMAMwXPJwmEGIvjjT39
	BY0DiXjbpeRl1jS/44yTTC2nnV4+ZmjDMbgwAycVHBqEaYUoA+Zg9doGNCaCgO4JZ8uo9ndOTIe
	Z4Q8DeXagGceNyG3to/9Ool3u7LSNtOKqNd9C7Jpf4EUGSpjRBABva
X-Google-Smtp-Source: AGHT+IGKbetRV9skZqHpoeEltspsN0gb7wQdXNJIlWTXhB69nTA2cA0uiCtPskBEA2gdsOO06l0FrorUEbx+
X-Received: from irogers.svl.corp.google.com ([2620:15c:2a3:200:273c:4116:6850:f9d3])
 (user=irogers job=sendgmr) by 2002:a05:6902:1244:b0:de5:60b6:fb9 with SMTP id
 t4-20020a056902124400b00de560b60fb9mr909174ybu.1.1714462761341; Tue, 30 Apr
 2024 00:39:21 -0700 (PDT)
Date: Tue, 30 Apr 2024 00:39:08 -0700
Message-Id: <20240430073908.1706482-1-irogers@google.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Subject: [PATCH v1] libtraceevent: Fix event-parse memory leak in process_cond
From: Ian Rogers <irogers@google.com>
To: linux-trace-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Leak sanitizer was reporting a stack trace with perf:
```
$ perf stat -e 'kvm:kvm_inj_exception' true

 Performance counter stats for 'true':

                 0      kvm:kvm_inj_exception

       0.001701473 seconds time elapsed

       0.000000000 seconds user
       0.001865000 seconds sys

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D1705137=3D=3DERROR: LeakSanitizer: detected memory leaks

Direct leak of 2 byte(s) in 1 object(s) allocated from:
    #0 0x7f413ee80778 in __interceptor_strdup ../../../../src/libsanitizer/=
asan/asan_interceptors.cpp:454
    #1 0x7f413ecb7b66 in __read_token libtraceevent/src/event-parse.c:1274
    #2 0x7f413ecb85bb in read_token libtraceevent/src/event-parse.c:1432
    #3 0x7f413ecbeaaa in process_entry libtraceevent/src/event-parse.c:2554
    #4 0x7f413ecc54ae in process_arg_token libtraceevent/src/event-parse.c:=
3698
    #5 0x7f413ecbb52e in process_arg libtraceevent/src/event-parse.c:2017
    #6 0x7f413ecbd05a in process_op libtraceevent/src/event-parse.c:2357
    #7 0x7f413ecc5a56 in process_arg_token libtraceevent/src/event-parse.c:=
3752
    #8 0x7f413ecbb52e in process_arg libtraceevent/src/event-parse.c:2017
    #9 0x7f413ecc5dd6 in event_read_print_args libtraceevent/src/event-pars=
e.c:3791
    #10 0x7f413ecc6511 in event_read_print libtraceevent/src/event-parse.c:=
3879
    #11 0x7f413ecda16c in parse_format libtraceevent/src/event-parse.c:7808
    #12 0x7f413ecda667 in __parse_event libtraceevent/src/event-parse.c:786=
6
    #13 0x7f413ecda71b in tep_parse_format libtraceevent/src/event-parse.c:=
7908
    #14 0x561672439029 in tp_format util/trace-event.c:94
    #15 0x561672439141 in trace_event__tp_format util/trace-event.c:109
    #16 0x56167230a429 in evsel__newtp_idx util/evsel.c:472
    #17 0x561672329f99 in add_tracepoint util/parse-events.c:552
    #18 0x56167232a5b4 in add_tracepoint_event util/parse-events.c:627
    #19 0x56167232ebf2 in parse_events_add_tracepoint util/parse-events.c:1=
313
    #20 0x561672411e0e in parse_events_parse util/parse-events.y:500
    #21 0x561672332409 in parse_events__scanner util/parse-events.c:1878
    #22 0x561672333cd4 in __parse_events util/parse-events.c:2146
    #23 0x561672334e74 in parse_events_option util/parse-events.c:2349
    #24 0x56167269ec23 in get_value tools/lib/subcmd/parse-options.c:251
    #25 0x56167269fe65 in parse_short_opt tools/lib/subcmd/parse-options.c:=
351
    #26 0x5616726a0e4d in parse_options_step tools/lib/subcmd/parse-options=
.c:539
    #27 0x5616726a1d86 in parse_options_subcommand tools/lib/subcmd/parse-o=
ptions.c:654
    #28 0x5616720e6ad2 in cmd_stat tools/perf/builtin-stat.c:2531
    #29 0x5616722b0f5d in run_builtin tools/perf/perf.c:350
$ cat /sys/kernel/tracing/events/kvm/kvm_inj_exception/format
name: kvm_inj_exception
ID: 1956
format:
        field:unsigned short common_type;       offset:0;       size:2; sig=
ned:0;
        field:unsigned char common_flags;       offset:2;       size:1; sig=
ned:0;
        field:unsigned char common_preempt_count;       offset:3;       siz=
e:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:u8 exception;     offset:8;       size:1; signed:0;
        field:u8 has_error;     offset:9;       size:1; signed:0;
        field:u32 error_code;   offset:12;      size:4; signed:0;
        field:bool reinjected;  offset:16;      size:1; signed:0;

print fmt: "%s%s%s%s%s", __print_symbolic(REC->exception, { 0, "#" "DE" }, =
{ 1, "#" "DB" }, { 3, "#" "BP" }, { 4, "#" "OF" }, { 5, "#" "BR" }, { 6, "#=
" "UD" }, { 7, "#" "NM" }, { 8, "#" "DF" }, { 10, "#" "TS" }, { 11, "#" "NP=
" }, { 12, "#" "SS" }, { 13, "#" "GP" }, { 14, "#" "PF" }, { 16, "#" "MF" }=
, { 17, "#" "AC" }, { 18, "#" "MC" }), !REC->has_error ? "" : " (", !REC->h=
as_error ? "" : __print_symbolic(REC->error_code, { }), !REC->has_error ? "=
" : ")", REC->reinjected ? " [reinjected]" : ""
```

The issue appears to be that when process_cond returns an error,
callers clear the variable holding the string but the string was never
freed. This change adds the free when process_cond returns
TEP_EVENT_ERROR.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-parse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index d607556..b6ae67e 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2373,6 +2373,8 @@ process_op(struct tep_event *event, struct tep_print_=
arg *arg, char **tok)
=20
 		/* it will set arg->op.right */
 		type =3D process_cond(event, arg, tok);
+		if (type =3D=3D TEP_EVENT_ERROR)
+			free(token);
=20
 	} else if (strcmp(token, ">>") =3D=3D 0 ||
 		   strcmp(token, "<<") =3D=3D 0 ||
--=20
2.44.0.769.g3c40516874-goog

