Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EA0156C0
	for <linux-trace-devel@vger.kernel.org>; Tue,  2 Jan 2024 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KGFmbSTg"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f1df517cf3so24845997b3.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Jan 2024 09:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704217707; x=1704822507; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y+uSr6NmdvEyAvoZSVy55aE6MU/3QVukYUTE1icdvzs=;
        b=KGFmbSTgzdtisr0G/DGhlxVpBmat4ycUSJESNQ1PszPTlReApKjtZ0suWdbbYiMnMM
         YUISHStRCPAVGlbR2kESZ2MQvqpMO2FSD/FvxIFf9mhF476CjMH69u6vcLrYR9kgCZPh
         5rceGjTHQApkEfKkbtBQEFKrSjgXTe22vBNYKYtDoaUqj+ofl/5Ah8B/HQPi7QqqEupQ
         gdkK1dpmIwx/TahxkL6AGabo4OwwX0RojXvDwoBZJdU+0gjq7F4neCl7LayC4AY46RM2
         l5pJJr9YyYBljxrPimhEpmMrv+IrapsPzhOlseZl4yWBJ1tKg7+taBBMr3fxepJl2bLl
         c54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704217707; x=1704822507;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y+uSr6NmdvEyAvoZSVy55aE6MU/3QVukYUTE1icdvzs=;
        b=WGsW/80RFQy6pyaeDMohyte44JLW7V6K6D8jt7P6tlQtxnrXHbnLDCWeUoAnDfHnOP
         jP5F72yAOy7BUYv2y82nVfgDHj/0ACYX+usF04QFY1D+ugYfb4OT3TNpTHtWtqiz4dRq
         nNOTExxHEa43PJiQ0+MNVkgB/eRxsONO7tj2sCNY3VInHdhRXQxWcPiYlJemwILogZjc
         03RRALFkpbPcUnY1mQedrpII6M1lJZtRUP3chBXHRvT3OiKDHA7UQAvfThzeSqVbsR8e
         dL88U2lXeVNFWP3hq0X0mgEa7vHj3WdyDSG3PqvXc8ysiR0uRq0+wrFHyPDwlWpEWKsl
         bUgQ==
X-Gm-Message-State: AOJu0YxMWArDG6UYH24kazEnXDDEwsL8m7sElaKDq60mrBRT9OtpHBW2
	6fzpgrFcw1pTm6YbzOwFYN0L+uKaHIHM3UTGQPAmylhCQ7vA2WKIYaVbS7xzJbiQDhtJuCZLZnX
	bZMSEvtkAyQOuJhaqbBubZWyVMqPi6JgGlI8QU4rzC8CdRxGKyL8fNNqJDH5hmPzPpen9lwF08c
	AeqqvYucTr+Q==
X-Google-Smtp-Source: AGHT+IGJPahJBQNddTUFroMeye2bUpqZT3rb03kDLb1o4rOp85FaRLzmiWnokOeHoil5IjW7iJKGN2Y+XGmH
X-Received: from irogers.svl.corp.google.com ([2620:15c:2a3:200:e2bd:f1f6:8ea6:8d6c])
 (user=irogers job=sendgmr) by 2002:a05:6902:2381:b0:dbe:4772:3966 with SMTP
 id dp1-20020a056902238100b00dbe47723966mr369554ybb.6.1704217707179; Tue, 02
 Jan 2024 09:48:27 -0800 (PST)
Date: Tue,  2 Jan 2024 09:48:16 -0800
Message-Id: <20240102174817.1051566-1-irogers@google.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH v1] libtracefs: Fix sqlhist used uninitialized error
From: Ian Rogers <irogers@google.com>
To: linux-trace-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix the following used uninitialized error detected by clang:
```
src/tracefs-sqlhist.c:657:13: error: variable 'extra_label' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
  657 |         } else if (expr == table->from) {
      |                    ^~~~~~~~~~~~~~~~~~~
src/tracefs-sqlhist.c:662:6: note: uninitialized use occurs here
  662 |         if (extra_label)
      |             ^~~~~~~~~~~
src/tracefs-sqlhist.c:657:9: note: remove the 'if' if its condition is always true
  657 |         } else if (expr == table->from) {
      |                ^~~~~~~~~~~~~~~~~~~~~~~~
src/tracefs-sqlhist.c:645:25: note: initialize the variable 'extra_label' to silence this warning
  645 |         const char *extra_label;
      |                                ^
      |                                 = NULL
1 error generated.
```

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/tracefs-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 3592000..e7a4158 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -642,7 +642,7 @@ static int update_vars(struct tep_handle *tep,
 	enum field_type ftype = FIELD_NONE;
 	struct tep_event *event;
 	struct field *field;
-	const char *extra_label;
+	const char *extra_label = NULL;
 	const char *label;
 	const char *raw = event_field->raw;
 	const char *event_name;
-- 
2.43.0.472.g3155946c3a-goog

