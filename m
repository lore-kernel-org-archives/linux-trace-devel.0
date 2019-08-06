Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3D4C31E40
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 05:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5897F206A2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 05:41:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrL3AUOg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfHFFlU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 01:41:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35534 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFFlU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 01:41:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so40877261pfn.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 22:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9vmSIGL7NhHoy1Z3RzZ/L1Z2RaBOvlIWLQdNkq+UEOo=;
        b=JrL3AUOgAYCIafcxf91HuL63qFVH6yeQ+BjChGzuRfiGw5hrHKcjx2INo8+23LrMim
         oX87leMyyOm1H1f4sqFNb1Q5kJLvuo6zJqoQs06LQzXHhBQysLjB98L5HQLSlWnpU34W
         FY/ivcWEI6W1Tr3R2YLdzPWlSF2Ze69xCBHEKkwl2wucU05iWE199gXwUbFqAo7ycMcv
         WVMnEz/8D4K2Qe8Fj7Na7fnzZfkzJaX3W4DTDNgoxHVm1CkqhzCqm2L7pANSJRTu1XDV
         Z+9ZuAVuhianCjOg3ZMqjNr1mXy8cGxe2OCJdKObRbNlpabdNov1q8D8gAVcj4xfFRuk
         kqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9vmSIGL7NhHoy1Z3RzZ/L1Z2RaBOvlIWLQdNkq+UEOo=;
        b=SvcIsqBEgEltVu6RoxvbiWIgI/lCR5mxLsQrBy3ZyhrmTyPau/vSeaa6m/Ry5I8xG2
         uqvmL2xtJMdNR58oBw00XeWoy4j3zSvo1p+ZRTJ3H3R44uQViv6C+KoZxhdi0EEtgjUp
         jrU5yp5Rwu+l08ku5iE8Hr0Sz0m/fws2FYhItIs7Yt/5oxCp8H7Hy5N486I/Qvi66uXh
         sc4N7Ai8SQHP35Pmxp42HRCB5MwMJ9vSIrE9F089tvCAx9F0L+JE7mAFzTZRGKc/B74u
         nGNKFn4wMqwjy969NqjsogBaKbEL5b3bxVNRCfRs8XNy2lYg5cOuPaJ0r2nQGuKIoY5j
         oG2g==
X-Gm-Message-State: APjAAAWKmuHEqhB9VYWiTU2CxI6fM7UaYudjbn4JmjB90o3KhXQ9pmmE
        Yr2ZvEDaxXv8qQbs6k7v1dHSYWKO
X-Google-Smtp-Source: APXvYqzxacRyg+u8HApm898vCK1lLDX8/vzhO3W1NpOhaFlzjNjUZUg7njyx3xrqFZq0FQSkSFcKbA==
X-Received: by 2002:a63:506:: with SMTP id 6mr1430990pgf.434.1565070079114;
        Mon, 05 Aug 2019 22:41:19 -0700 (PDT)
Received: from localhost ([175.223.3.169])
        by smtp.gmail.com with ESMTPSA id e124sm137779141pfh.181.2019.08.05.22.41.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 22:41:18 -0700 (PDT)
Date:   Tue, 6 Aug 2019 14:41:15 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 1/2] parse-events: deref pointer for proper sizeof()
Message-ID: <20190806054115.GA16977@jagdpanzerIV>
References: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
 <20190805232103.04c6ad28@oasis.local.home>
 <20190806051418.GB851@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806051418.GB851@jagdpanzerIV>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On (08/06/19 14:14), Sergey Senozhatsky wrote:
> Hi Steven,
> 
> I just realised that the patches are against v1.1.1, not the master
> branch. Let me know if it's not OK.
> 
> 
> I've some issues building v1.1.1.
> 
> 	swig -Wall -python -noproxy ctracecmd.i
> 	parse-events.h:676: Error: Syntax error in input(3).
> 
> Which is, probably, this 'bool' variable of type filter_arg_boolean
> 
> struct filter_arg {
>         enum filter_arg_type    type;
>         union {
>                 struct filter_arg_boolean       bool;        <<<< 676
>                 struct filter_arg_field         field;
>                 struct filter_arg_value         value;
>                 struct filter_arg_op            op;
>                 struct filter_arg_exp           exp;
>                 struct filter_arg_num           num;
>                 struct filter_arg_str           str;
>         };
> };
> 
> Is this a known problem?

This patch seems to do the trick for me.

---

diff --git a/parse-events.h b/parse-events.h
index 3a4ef08..01be4f0 100644
--- a/parse-events.h
+++ b/parse-events.h
@@ -673,7 +673,7 @@ struct filter_arg_str {
 struct filter_arg {
 	enum filter_arg_type	type;
 	union {
-		struct filter_arg_boolean	bool;
+		struct filter_arg_boolean	boolean;
 		struct filter_arg_field		field;
 		struct filter_arg_value		value;
 		struct filter_arg_op		op;
diff --git a/parse-filter.c b/parse-filter.c
index 0d448cb..13f3422 100644
--- a/parse-filter.c
+++ b/parse-filter.c
@@ -359,7 +359,7 @@ create_arg_item(struct event_format *event,
 			if (strcmp(token, COMM) != 0) {
 				/* not a field, Make it false */
 				arg->type = FILTER_ARG_BOOLEAN;
-				arg->bool.value = FILTER_FALSE;
+				arg->boolean.value = FILTER_FALSE;
 				break;
 			}
 			/* If token is 'COMM' then it is special */
@@ -487,7 +487,7 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 				free_arg(left);
 				free_arg(arg);
 				op->type = FILTER_ARG_BOOLEAN;
-				op->bool.value = FILTER_FALSE;
+				op->boolean.value = FILTER_FALSE;
 				break;
 			}
 
@@ -772,7 +772,7 @@ enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
 
 		/* bad case */
 	case FILTER_ARG_BOOLEAN:
-		return FILTER_VAL_FALSE + arg->bool.value;
+		return FILTER_VAL_FALSE + arg->boolean.value;
 
 		/* good cases: */
 	case FILTER_ARG_STR:
@@ -871,7 +871,7 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
 		free_arg(arg);
 		arg = allocate_arg();
 		arg->type = FILTER_ARG_BOOLEAN;
-		arg->bool.value = ret == FILTER_VAL_TRUE;
+		arg->boolean.value = ret == FILTER_VAL_TRUE;
 	}
 
 	return arg;
@@ -1116,7 +1116,7 @@ process_event(struct event_format *event, const char *filter_str,
 	if (!*parg) {
 		*parg = allocate_arg();
 		(*parg)->type = FILTER_ARG_BOOLEAN;
-		(*parg)->bool.value = FILTER_FALSE;
+		(*parg)->boolean.value = FILTER_FALSE;
 	}
 
 	return 0;
@@ -1139,7 +1139,7 @@ static int filter_event(struct event_filter *filter,
 		/* just add a TRUE arg */
 		arg = allocate_arg();
 		arg->type = FILTER_ARG_BOOLEAN;
-		arg->bool.value = FILTER_TRUE;
+		arg->boolean.value = FILTER_TRUE;
 	}
 
 	filter_type = add_filter_type(filter, event->id);
@@ -1369,9 +1369,9 @@ static int copy_filter_type(struct event_filter *filter,
 		arg = allocate_arg();
 		arg->type = FILTER_ARG_BOOLEAN;
 		if (strcmp(str, "TRUE") == 0)
-			arg->bool.value = 1;
+			arg->boolean.value = 1;
 		else
-			arg->bool.value = 0;
+			arg->boolean.value = 0;
 
 		filter_type = add_filter_type(filter, event->id);
 		filter_type->filter = arg;
@@ -1442,8 +1442,8 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
 		arg = filter_type->filter;
 		if (arg->type != FILTER_ARG_BOOLEAN)
 			continue;
-		if ((arg->bool.value && type == FILTER_TRIVIAL_FALSE) ||
-		    (!arg->bool.value && type == FILTER_TRIVIAL_TRUE))
+		if ((arg->boolean.value && type == FILTER_TRIVIAL_FALSE) ||
+		    (!arg->boolean.value && type == FILTER_TRIVIAL_TRUE))
 			continue;
 
 		event = filter_type->event;
@@ -1497,10 +1497,10 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
 			continue;
 		switch (type) {
 		case FILTER_TRIVIAL_FALSE:
-			if (filter_type->filter->bool.value)
+			if (filter_type->filter->boolean.value)
 				continue;
 		case FILTER_TRIVIAL_TRUE:
-			if (!filter_type->filter->bool.value)
+			if (!filter_type->filter->boolean.value)
 				continue;
 		default:
 			break;
@@ -1551,10 +1551,10 @@ int pevent_filter_event_has_trivial(struct event_filter *filter,
 
 	switch (type) {
 	case FILTER_TRIVIAL_FALSE:
-		return !filter_type->filter->bool.value;
+		return !filter_type->filter->boolean.value;
 
 	case FILTER_TRIVIAL_TRUE:
-		return filter_type->filter->bool.value;
+		return filter_type->filter->boolean.value;
 	default:
 		return 1;
 	}
@@ -1783,7 +1783,7 @@ static int test_filter(struct event_format *event,
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
 		/* easy case */
-		return arg->bool.value;
+		return arg->boolean.value;
 
 	case FILTER_ARG_OP:
 		return test_op(event, arg, record);
@@ -2147,7 +2147,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
 		str = malloc_or_die(6);
-		if (arg->bool.value)
+		if (arg->boolean.value)
 			strcpy(str, "TRUE");
 		else
 			strcpy(str, "FALSE");
