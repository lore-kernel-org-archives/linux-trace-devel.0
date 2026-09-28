Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6A83A9605
	for <linux-trace-devel@vger.kernel.org>; Mon, 28 Sep 2026 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622722; cv=none; b=T6HEPyiKdqRn9rAozLe7Zn6LHDk651j3uZqNiJch4+hDR1wUm6fNeGMknzKftqsLHaTmTUdt98boWvAATbwc+OOXBShtN1X0HSaJH4fqXb2Gb7eBVRaI3hiYZKXlxslysZO3mzqfAnI2F9wnVCp+adHPhej7VgDnooChMrGXYSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622722; c=relaxed/simple;
	bh=V2eOuuzLUDKgwlSG9KucmuyuoT9gBa0ytRG9O8KLgHQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XNzRv+LbK/CIioNIugOSb2p2Mg8PoRVh3Sr4P35w1AgOdxb/hUDuzmh+w8ttdkUJaQ9unuI+jIFjI1xgDF7XZpuM2FkbeQiyU5eL3t2WVpbJyut4IqqjleGgcIy2nyPFoJKx+Wix9shS7JKt3cQ2n28HyPtimRCKLyhSqxQN8yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=naml7s4A; arc=none smtp.client-ip=74.125.82.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="naml7s4A"
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1438fef603cso6765499c88.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Sep 2026 12:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790622720; x=1791227520; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0zw1lxWbLMGmZ/9TQKjvMdf2bKKjYq9pDKlQ7WUAKFw=;
        b=naml7s4AobjquIBplFjkeWmVcO9ZhRGOknmFRlqWuclPYluuj2YoztliFgpn4/pnaH
         OSJJQgRLZajwQ4MJpcP2ZIt/dT08AYdCyYF3Qmz6oP2EEoX/aZTyyg2SuhV3YKplEzx0
         1s5SZ3j4j6K/kqCeMFQYOpo/7p/Fhi/Q49KNOldLZ1NfjxsbUrqDQ1RnQ2fZ6BnS262c
         dI4iTA9zBNsUsQ77xgfD3HORPY25S10mXuFXv0Z5XpTc3yPH36PI8hlgj7FP8vXa6lp9
         /2Vug0DHex5wDOrtZRh6ghYO2S9wl1qclL54GCrfO4oCv+o+lJ+6kkUalIWJ8KlmkNBU
         iexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790622720; x=1791227520;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0zw1lxWbLMGmZ/9TQKjvMdf2bKKjYq9pDKlQ7WUAKFw=;
        b=TNI5tyE3oXFSZmq2JPl/Tvs1TvrvWIiZf2duWZ7Tv0P0Lsqzu6B4Rf4HQbypjLTenD
         O+zLxTOPQcRdLdSYm/N6HJctDORdCw1Q4piDrDhdgwkcBqbyoPrcSvR9qRWPVU98bpSX
         EP6AIEF9Mv8TIZlH0ZUDWcbzqCP+aRUogPvZHyjoYVkmntaaMveH8/ParP5LkQtr/7EM
         z84bKNT+lUMwBUshftoq/dsR+JKdQcU+3vd9Z1V/ff+xZhVJTYUqchVjlnccx3ZDm/7F
         oU7LOV/50STx6yHJX0t0esUYFJK8NnK8ZwTNMRdiLXwtJyQbBPeQr+lcz2My6aViw6RD
         XguQ==
X-Gm-Message-State: AFuF++mbePQmSpkBCnQnOoK2mLlSxqlh9mrz5hmR3gilCmv839+2cIVo
	uKiTF9zXbNuUWrE/OB8EeMaOYD6YHwduUtNHSueF0XIBEHnBaMpFYEx4eeciTLkp2UxQaZu/hHj
	kthK/sDEp4g==
X-Received: from dlbem1.prod.google.com ([2002:a05:7022:1001:b0:143:9658:f913])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:1584:b0:145:388:2445
 with SMTP id a92af1059eb24-146cddbcdeamr13786315c88.4.1790622719920; Mon, 28
 Sep 2026 12:11:59 -0700 (PDT)
Date: Mon, 28 Sep 2026 12:11:55 -0700
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928191155.3712558-1-irogers@google.com>
Subject: [PATCH] libtraceevent: Fix leaks and NULL check in process_int_dynamic_array()
From: Ian Rogers <irogers@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

process_int_dynamic_array() reads the name of the array's field into
token, but only frees it on the "out" error path, so each
__print_dynamic_array() parsed leaks the name. The kernel's syscall events
use it for user space buffers, such as write's buf. The early return, when
the first argument isn't a name, leaks the token too, and unlike the other
error path it doesn't set *tok to NULL.

Also check the result of alloc_arg() rather than arg, which can't be NULL,
so that an allocation failure is reported rather than dereferenced.

Found with LeakSanitizer running perf trace.

Fixes: 3f9655198727 ("libtraceevent: Add support for __print_dynamic_array() macro")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-parse.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 4bd5c1b..14e1b91 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3473,8 +3473,11 @@ process_int_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, ch
 	 * the index into where the array starts.
 	 */
 	type = read_token(event->tep, &token);
-	if (type != TEP_EVENT_ITEM)
+	if (type != TEP_EVENT_ITEM) {
+		free_token(token);
+		*tok = NULL;
 		return TEP_EVENT_ERROR;
+	}
 
 	/* Find the field */
 	field = tep_find_field(event, token);
@@ -3490,7 +3493,7 @@ process_int_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, ch
 		goto out;
 
 	arg->int_array.field = alloc_arg();
-	if (!arg) {
+	if (!arg->int_array.field) {
 		do_warning_event(event, "%s: not enough memory!", __func__);
 		goto out;
 	}
@@ -3499,6 +3502,7 @@ process_int_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, ch
 	arg->int_array.field->dynarray.field = field;
 	arg->int_array.field->dynarray.index = 0;
 
+	free_token(token);
 	return read_token_item(event->tep, tok);
 out:
 	free_token(token);

base-commit: 51d47b0eb2b40d4273fb461782fe9a01db0f901c
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

