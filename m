Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB922907
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jul 2024 16:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721665160; cv=none; b=f7mdILWnFeLDj/XER37Y2El5U8J9ohVQWnacA4pHrp1dohuooLhWHS7JHRxn75MROjRDrajn1LRcHDnXmb7h6cOXG2IsYYwYvJO3H38HcAaYCvHEYjZR4UP6KldD4AM4xpvosQSDchLqbqxSko6r2jIRbIQK0CcCn7Rgcxxm9YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721665160; c=relaxed/simple;
	bh=/F9srybdAfWjCRJ3FBnOMYBnxkn8T3njMA1/Asph/GY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WnUaXSQb46n77ETYHOxq+HSUr7GlJa/eS2kJyA921v9mmVQR4gYhSXerTXQTwHfc2xTKmK93hqS8turstDoZpTOcJ5NnHoVZEBJJS7O0tzl5Ymg8YkM/4g/QxRl3JYsNJO7EoJBmZpGLcCQVTqSgTUMMYOZn3dSPAlDvwD6Tqvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkVuGPVv; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkVuGPVv"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-6bce380eb96so2414066a12.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jul 2024 09:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721665159; x=1722269959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fX5aDjFvccfadytGRH9QD5hC3Hny3tTnfyYgFcAk/Bo=;
        b=HkVuGPVvYWlz1PxWq1XlWc4WzG75G18D2dgVo5ogiflbw1Acg7OP1kMOrOdeEW0dpT
         vWA2NYdQWhHE5O4YhlpMuLe9YRMxGJmdxzTyaYjs5DP4dtGX/R1fvAINFqJRkZ8eR3Zp
         Xu2vBd3XeU/0vRiKO5ChDfdS3hGbFQejKP2Uu/Q+2bupBJOuDibMP7CA3zjNVUT4IyUu
         UHqI4JCvehQ2rbji4/mYjrI/lsly71qCfQQT41aaZoerwwjpe7MRjAZn8sFFvE7ZZY5l
         6UqOKV52rNT0TsJN2MqffmMBaB08LW+NNguKIQrWP866QS/9imxWb631k9Bdj/A/NPGs
         cogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721665159; x=1722269959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fX5aDjFvccfadytGRH9QD5hC3Hny3tTnfyYgFcAk/Bo=;
        b=vcOlMY4ouJU7I57PMYfKLP727q+l0xjEpUt4vfq01m490bvfAok0eIjHa/Ix8ROclZ
         ai/lvERkfmEh78mlczGJrubXQyQDBKycCngCRs8voVJZAhx6COmYld4ZKpkwac+Yoiwx
         lBqEF5+q23nQ4/WgSul/ShyCQwywYzvoljw5DyjlznTprUfvvEtw9NYoLap7iNdI5vjU
         WsUEPgX5eYka1Jy879Wc8OtIsslM0014oiP8mjJU7nglxGr2IY0XVBRMVEi4rN3ml5Ua
         552Kf+H9j48zu0HUOEwAjx/MwRcw5PkXcs76Jg7K2NoVdDNBlPQNIEK7TzFBZxTf6s89
         aV8Q==
X-Gm-Message-State: AOJu0YzbuXf7t3wdh7HUrXcT81F9Nyw/lRuGdePa1QsrPCW1xKhePjGO
	0dxbWajw6u32U+lMdG7f+20Be0TiPV9YcgfvoghYtGEyEaRtCsF/im27BQ==
X-Google-Smtp-Source: AGHT+IEYTAN5ELkfaPejM/hNlfGQslAkds8LBTiGUT9vdZopM1UvvLQWLsgzi+//mgtmzE3xXT3APg==
X-Received: by 2002:a05:6a20:7491:b0:1c0:defa:b67d with SMTP id adf61e73a8af0-1c4286883c7mr5663807637.46.1721665158432;
        Mon, 22 Jul 2024 09:19:18 -0700 (PDT)
Received: from bangji.hsd1.ca.comcast.net ([2601:647:4400:a940:365b:a18b:f804:feb2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb7730fb21sm8438585a91.18.2024.07.22.09.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 09:19:18 -0700 (PDT)
From: Namhyung Kim <namhyung@gmail.com>
X-Google-Original-From: Namhyung Kim <namhyung@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Ian Rogers <irogers@google.com>
Subject: [PATCH v2] libtraceevent: Fix a double free in process_op()
Date: Mon, 22 Jul 2024 09:19:16 -0700
Message-ID: <20240722161917.991077-1-namhyung@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When process_cond() failed, it freed the token but didn't reset the
arg->op.op to NULL.  So it tried to free the arg->op.op again from
free_arg() from the caller and resulted in a double free.

And Steve found another location that needs an update.  Let's handle
the error in consolidate_op_arg() instead.

Signed-off-by: Namhyung Kim <namhyung@google.com>
---
 src/event-parse.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 9f0522c..ba4a153 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2197,21 +2197,24 @@ static int set_op_prio(struct tep_print_arg *arg)
 	return arg->op.prio;
 }
 
-static int consolidate_op_arg(struct tep_print_arg *arg)
+static int consolidate_op_arg(enum tep_event_type type, struct tep_print_arg *arg)
 {
 	unsigned long long val, left, right;
 	int ret = 0;
 
+	if (type == TEP_EVENT_ERROR)
+		return -1;
+
 	if (arg->type != TEP_PRINT_OP)
 		return 0;
 
 	if (arg->op.left)
-		ret = consolidate_op_arg(arg->op.left);
+		ret = consolidate_op_arg(type, arg->op.left);
 	if (ret < 0)
 		return ret;
 
 	if (arg->op.right)
-		ret = consolidate_op_arg(arg->op.right);
+		ret = consolidate_op_arg(type, arg->op.right);
 	if (ret < 0)
 		return ret;
 
@@ -2375,8 +2378,6 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
-		if (type == TEP_EVENT_ERROR)
-			free(token);
 
 	} else if (strcmp(token, ">>") == 0 ||
 		   strcmp(token, "<<") == 0 ||
@@ -2587,7 +2588,7 @@ static int alloc_and_process_delim(struct tep_event *event, char *next_token,
 	if (type == TEP_EVENT_OP) {
 		type = process_op(event, field, &token);
 
-		if (consolidate_op_arg(field) < 0)
+		if (consolidate_op_arg(type, field) < 0)
 			type = TEP_EVENT_ERROR;
 
 		if (type == TEP_EVENT_ERROR)
@@ -3818,7 +3819,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 			type = process_op(event, arg, &token);
 			free_token(token);
 
-			if (consolidate_op_arg(arg) < 0)
+			if (consolidate_op_arg(type, arg) < 0)
 				type = TEP_EVENT_ERROR;
 
 			if (type == TEP_EVENT_ERROR) {
-- 
2.45.2.1089.g2a221341d9-goog

