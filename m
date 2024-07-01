Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E095847C
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jul 2024 02:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719800777; cv=none; b=RxgpUQYx5nNzh/ZHQZ9ICncfY3PRAlWK2LPcn+akiFNrui8mn3T2N038nW5jr/g/jg7a6k3RC1MrJHmsZUwDtLMI+FKqd0ruRTYAblXjBfJsfH27iqGW7JVO7J1h8LN3Dsnp/QtMqsCm15iPJPJSeaTdrGleza93C1Pq3RFT7OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719800777; c=relaxed/simple;
	bh=XJPHs4g4+P/m5j+HEwz97bhXjeBRHKwKjWGI2q86eSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lYRbFcye22y9OxV0OvspsnJO6WjzH52CaFyvz1O5jD0AG73wy14z9DBAPfzcWQR0MaaL3NxbkMr9retK+l2xIHcew/HfCZ553oqtheQJMMEp3EsevRE6ih5PPYZpBkL6MzVxreftY1O7awt++3QcUmneK6XEQlDaryAoRB8uu5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XelIzedt; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XelIzedt"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-706627ff48dso1759269b3a.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 30 Jun 2024 19:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719800775; x=1720405575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hcQFTzt0nNrj5k8Fpp5j/dGnxjZ0VqyzD7HyZsSbtB0=;
        b=XelIzedtbvgQ1qMFuKN9bjfcg0wCOFpCEZMsco6sFixVEoUG+kMRNiP2LonADDWPx2
         rcwLcV4MflPoVD+FDzdiTxUHpFzlRMAmvlKlmKkmS+z/JZFodozSVA8/2pQcoCNHnpfb
         UWTexhqr7YPF6yBgHFGcmVXlDH6q72VveFpZ8SAb70hOF70FuR0okM7t43kMntqAaSuj
         ItG6YJM+Id/Yp/jzTFrVbpexPdjx7gs/pNXkp7gq8wHV8ReTCsEaEfJyn1+ghpaXUphF
         2wXtslMKU5Nz/PC2ewPHdm4YdFyMEgJlpbmZZ+QAoLdAWggfVbsjtj7fGjIeWfVq3HG8
         nmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719800775; x=1720405575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hcQFTzt0nNrj5k8Fpp5j/dGnxjZ0VqyzD7HyZsSbtB0=;
        b=J8iINv5zNjnpBTcvx3viG1IaC9Ugo8E2XZHuhzQb9VbqLKxioEQDlOX32Q/2OhsfCB
         UejTt2LIHGIDVWoT6SYStZQs8E2jDt4kf1TTJOpr80pSbIkvKi6W97AUjA1Ar9w1oVPQ
         WliT0lou/Pr6zzUOmCnaKzRT3/tQYKst7DBH0jHxKLJcdbl6SshzjV5CIgTlWgiE9nJP
         1R+dBq7xsBDVbmZVJezf7joa7Ka4/b8VaZYWnMrTpEnfxRDI1oewDG6s7qPRqqTmmMuO
         xmTSZPTly51auUHY1Z6HRGbmRVmt1tsYb7uBKFvzsyFEm9owXsLgOhHzONi0IJPnM3sH
         ZBQw==
X-Gm-Message-State: AOJu0Ywn0JTpnXM/bHP+aKTP1GmCS/aDMXWqtkZrsvlQpjBmtLev+iYd
	QuOXVWGfN0IWFdqIe5ZMLTVyY7LSGvrXA2JNYNXrAjvsNRkKXRH/Q64/rLW23nk=
X-Google-Smtp-Source: AGHT+IG9Pvq3J7SIqK2Arj679hyfj5aCnPPT6jd5y6gZ79ZlaCnJIk6X/NccE+vaM+yRMC8kMpdI5A==
X-Received: by 2002:a05:6a00:c96:b0:6ed:cd4c:cc1a with SMTP id d2e1a72fcca58-70aaad39edcmr7526853b3a.8.1719800775197;
        Sun, 30 Jun 2024 19:26:15 -0700 (PDT)
Received: from localhost.localdomain ([112.65.140.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6d00b5aasm4250008a12.83.2024.06.30.19.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 19:26:14 -0700 (PDT)
From: Tw <tw19881113@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Tw <tw19881113@gmail.com>
Subject: [PATCH v2] Fix double free issue in event_read_print_args
Date: Mon,  1 Jul 2024 10:24:46 +0800
Message-ID: <20240701022446.23492-1-tw19881113@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The corner case is that when we encounter a invalid right argument of a condition operation.
Currently, we free token immediately, but it will also be freed when free `arg->op.op`.

BTW, the crash calltrace as follows:

Program received signal SIGSEGV, Segmentation fault.
get_meta (p=<optimized out>) at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
141     /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h: No such file or directory.
(gdb) bt
    at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
    at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/free.c:105
    at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1128
    list@entry=0x7ff7b18768)
    at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1417
    at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:3895
    sys=<optimized out>)
    at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7824
    size=<optimized out>, sys=sys@entry=0x7ff7ff51c0 "kvm")
    at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7882
    buf=0x7ff7b0c610 "kvm_sys_access", size=549616874800, sys=0x7fffffe0b2 "me", sys@entry=0x7ff7ff51c0 "kvm")
    at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7945
    tracing_dir=tracing_dir@entry=0x7ff7ffc660 "/sys/kernel/tracing", system=system@entry=0x7ff7ff51c0 "kvm",
    check=false)
    at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1062
    system=0x7ff7ff51c0 "kvm")
    at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1084
    tep=tep@entry=0x7ff7ffc830, sys_names=sys_names@entry=0x0, parsing_failures=0x0,
    parsing_failures@entry=0x7fffffe7b0)
    at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1284
    sys_names@entry=0x7ffffff880)
    at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1355
    tracing_dir=0x6500006c6f6f62 <error: Cannot access memory at address 0x6500006c6f6f62>)
    at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1377

Signed-off-by: Tw <tw19881113@gmail.com>
---
 src/event-parse.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 9f0522c..1f51ee9 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2375,8 +2375,6 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
-		if (type == TEP_EVENT_ERROR)
-			free(token);
 
 	} else if (strcmp(token, ">>") == 0 ||
 		   strcmp(token, "<<") == 0 ||
@@ -3787,7 +3785,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 {
 	enum tep_event_type type = TEP_EVENT_ERROR;
 	struct tep_print_arg *arg;
-	char *token;
+	char *token = NULL;
 	int args = 0;
 
 	do {
@@ -3817,6 +3815,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 		if (type == TEP_EVENT_OP) {
 			type = process_op(event, arg, &token);
 			free_token(token);
+			token = NULL;
 
 			if (consolidate_op_arg(arg) < 0)
 				type = TEP_EVENT_ERROR;
-- 
2.45.1

