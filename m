Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FB62AD39
	for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2024 03:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719373193; cv=none; b=LMzvh/SdiLhNEilU8FL1mZmq1NKPF9OL2k2UsjzR2j16GbnNHzNA0i8+JYsqgc8dPcXByDfBDUqsz9zQ6DKMtpUN5EScbgcdmsOG1gMl9AIuDmf0Sh+E0qPc4XIMAXDynyKqBf8tOF0CpQAj+iiRPU1kMhKRddf0GN7RNtQxzPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719373193; c=relaxed/simple;
	bh=UkzGGEydAPu5Rv5+YCQ1ZmLDkDcci/ADY8bXWV/So/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dwlX7nEnfI/wWX+wr017SPZyROqh1f6ScT6HQfknZBdAOt8tCK0IUyMDAYC/Wm7B4q1ptjdHTldWdiJHV/7szpomCXFGlYTzhplqwHFhxynGHOno+BCOLC3Lt12jG2LYhYX6FCTJURrZu7ZTqjsRwNYwrOnQ2zBFeeis0aLGfm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ck0+busf; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ck0+busf"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2c81ce83715so3783425a91.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jun 2024 20:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719373191; x=1719977991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zGv+XINKXEOzigktHmewabyX4a5vgGUFetd9a4yU8b0=;
        b=ck0+busfRgrK2+Dj9DcnIQC0RwZ2RaMME2UOQ3Vcd4qaZDOzovGkas7Qde9+Rfrhtu
         FakKPAPjuFU760VI2QM2dnaHJc3/kII62DFXDD3jEmINjgPm6+EYw8yV83cLvQhsd6LV
         OweKGwFogw8jnW+fyfqi1rp1u30Mg9O3qTNGpamieAj4sOFWncQq6hkuYQQtmByHy9/B
         9r6/ffmUMW8P2MJ1v6PfdiXApk8Q1NvAB9KNuCkcLYO4NQPiyUpWMliZz31v+Z8QJQ+o
         d9dfqVkfxfsVjxnp1fMtGeA9WSFttO/UkvyQVyQN1rgGtiUYYDZW1QKT6+58HESwV58I
         otaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719373191; x=1719977991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGv+XINKXEOzigktHmewabyX4a5vgGUFetd9a4yU8b0=;
        b=ShlFk9xTHsninEh4ijsEQdgfX7TgXtH5Qb+If9nJbkalmge12KkxxZOxPn3RyTlpfY
         M9+/GjS8GvCktz8ZitOokU1OqCcGEsMOtQ4r1ISlX8j/58SWcTDg9WhiqmlVwDDbgrhW
         uSz5b+7Sc/ttl6IN2iGIi5p/p3mH1U0g7TJWD0IRdJA3zlxyKhmn+TmoHOoIDnao5aP4
         zt2EdAkbkyBHmD4+sB4w047ClvC6p2WIje2ZrHvrLEr0WmbWdnoMVm/KvQTizzE9MejR
         F0xjOCGheL00PPvYwwMMBRBrdcdA5TqjN5wW+RLQdCKgAmj262DRl61a/2SWZTNqLkvx
         pYCA==
X-Gm-Message-State: AOJu0YxJClNIDnLRmtXBpxAr8m4nMpLfaTYJg/hotzrrKyJvbEK6o9MG
	q1n5kMWKBg3w9DM7VMvIPWARNNMCquwq1I+6fRQMNQvCdHRt1oa6WVGxRYDp
X-Google-Smtp-Source: AGHT+IGjQllokweLNI5z3Gh6BBi30F418hgwmUlpGwFGBkBR0lev4j+JLodWG3CoeT8iD+G7F9t21w==
X-Received: by 2002:a17:90a:b012:b0:2c8:5bd3:551a with SMTP id 98e67ed59e1d1-2c85bd35694mr8863088a91.35.1719373191372;
        Tue, 25 Jun 2024 20:39:51 -0700 (PDT)
Received: from bangji.hsd1.ca.comcast.net ([2601:647:4400:a940:fa2a:95f:932b:728d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c8d7e55c37sm456224a91.7.2024.06.25.20.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 20:39:51 -0700 (PDT)
From: Namhyung Kim <namhyung@gmail.com>
X-Google-Original-From: Namhyung Kim <namhyung@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Ian Rogers <irogers@google.com>
Subject: [PATCH] libtraceevent: Fix a double free in process_op()
Date: Tue, 25 Jun 2024 20:39:49 -0700
Message-ID: <20240626033949.1017381-1-namhyung@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
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

Signed-off-by: Namhyung Kim <namhyung@google.com>
---
 src/event-parse.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 9f0522c..c327917 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2375,8 +2375,11 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
-		if (type == TEP_EVENT_ERROR)
-			free(token);
+		if (type == TEP_EVENT_ERROR) {
+			/* arg->op.op (= token) will be freed at out_free */
+			arg->op.op = NULL;
+			goto out_free;
+		}
 
 	} else if (strcmp(token, ">>") == 0 ||
 		   strcmp(token, "<<") == 0 ||
-- 
2.45.2.741.gdbec12cfda-goog

