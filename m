Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EB2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Oct 2022 15:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJRPRI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Oct 2022 11:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJRPRH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Oct 2022 11:17:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C394CC0989
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Oct 2022 08:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666106223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynT9IkrYJsbhyOmqoyyaVlY7GdUEFeWxGVQ45kAczMk=;
        b=DjvM/zV9TSHu6IOExOmZ0sA67X5qco4e7J+b6zaWnZJ2hszddDqWGoy0tzeYLY7L4FaOfh
        BbGBAQyJvhQEmrDBAZT0+2SAmE8cjo/AUeZlmlpzNdmO4Yca5tpYUFMPkpdJtTP2yQsd8w
        8dagf6/VlGS4MVrv+6K37r6CIpDKY48=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-2-Lf8bi7O1OGN_1PCXr-LA-1; Tue, 18 Oct 2022 11:17:02 -0400
X-MC-Unique: 2-Lf8bi7O1OGN_1PCXr-LA-1
Received: by mail-qt1-f197.google.com with SMTP id c11-20020ac87dcb000000b0039cdb815f3bso7692814qte.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Oct 2022 08:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynT9IkrYJsbhyOmqoyyaVlY7GdUEFeWxGVQ45kAczMk=;
        b=DtM7oY2B5NjUlGvhxaw+M/n4TCWJHJ+ZoicTnakp4zqVvoLLwSKQp6tEZBGoqpyWhy
         E5nHf2ll7Mxedwh3Wj8tCH7V0dDtw6GOYyRHzjVuFTkvwp6/MAcbtIP4BA6Qei1c26Ay
         qcMzespXs4Rlzje1nC2apz0wOPExHxAX8INLffVWgSPqcMlqr3kwUBdCyleLTaMhIGRU
         8fCpq+GwUT+lJjXOT4w2kSRbW94LYDEJvqWD+ivMmzJihUuUUkegqgSDmA8kQr3W+9hg
         OBF6aP3jLF0dSnyDuaPFBSOaAXAnzvJ6dE0mnQBC51N7JGn5amIxQ4tp1eSWC9mEabpr
         EjFA==
X-Gm-Message-State: ACrzQf2Vdb6AR+Wdq5kHoiIIIqcENR4d+scpzBTIjfRkb4A07XGa2Pxa
        mGQwNfs5sZO1ogKKx4dzumfwTi5Kwn2/OJaexfh+j2foA/e2w6wT2GF1YJULuUQXLuLckjruL+L
        Q9Tt68Z8JAn/PwcAyT+f8sRuM6OTsPXpiTP0hxQvoD1x2QqemiP6R/j87ZaB4H/HEMLB/VBb9yJ
        bRvhhDC7o=
X-Received: by 2002:a05:622a:420d:b0:38d:961c:a57c with SMTP id cp13-20020a05622a420d00b0038d961ca57cmr2507775qtb.678.1666106219935;
        Tue, 18 Oct 2022 08:16:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6bmkEH+mX6iPw7gWaF5P4+3bJ96TbvWR/pcVSYyioUkGprya+CG/I62txG1kzTHMzu1N74Ww==
X-Received: by 2002:a05:622a:420d:b0:38d:961c:a57c with SMTP id cp13-20020a05622a420d00b0038d961ca57cmr2507739qtb.678.1666106219505;
        Tue, 18 Oct 2022 08:16:59 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id s23-20020a05622a1a9700b003988b3d5280sm2159646qtc.70.2022.10.18.08.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 08:16:58 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH 1/2] libtraceevent: Add boiler-plate code for cpumask types
Date:   Tue, 18 Oct 2022 16:16:29 +0100
Message-Id: <20221018151630.1513535-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221018151630.1513535-1-vschneid@redhat.com>
References: <20221018151630.1513535-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A cpumask event field type was recently added to Linux, which helps
distinguish any odd bitmask from a cpumask. Right now this field type is
not recognized by libtraceevent:

  [ipi:ipi_send_cpumask] function __get_cpumask not defined
  CPU 0 is empty
  CPU 1 is empty
  CPU 3 is empty
  cpus=4
	    echo-173   [002]    11.859745: ipi_send_cpumask:     [FAILED TO PARSE] cpumask=ARRAY[02,
00, 00, 00, 00, 00, 00, 00] callsite=0xffffffff81121013

Since a cpumask is still a bitmask, define the boiler plate code for this
new field type and wire it all to bitmask handling.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/traceevent/event-parse.h |  1 +
 src/event-parse.c                | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index f749cc2..2bb0f3e 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -242,6 +242,7 @@ enum tep_print_arg_type {
 	TEP_PRINT_OP,
 	TEP_PRINT_FUNC,
 	TEP_PRINT_BITMASK,
+	TEP_PRINT_CPUMASK,
 	TEP_PRINT_DYNAMIC_ARRAY_LEN,
 	TEP_PRINT_HEX_STR,
 };
diff --git a/src/event-parse.c b/src/event-parse.c
index 980e980..362720c 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1083,6 +1083,7 @@ static void free_arg(struct tep_print_arg *arg)
 		free(arg->string.string);
 		break;
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 		free(arg->bitmask.bitmask);
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY:
@@ -2816,6 +2817,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 	case TEP_PRINT_STRING:
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2845,6 +2847,7 @@ static char *arg_eval (struct tep_print_arg *arg)
 	case TEP_PRINT_STRING:
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -3325,6 +3328,17 @@ process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
 	return TEP_EVENT_ERROR;
 }
 
+static enum tep_event_type
+process_cpumask(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
+		char **tok)
+{
+	enum tep_event_type type = process_bitmask(event, arg, tok);
+	if (type != TEP_EVENT_ERROR)
+		arg->type = TEP_PRINT_CPUMASK;
+
+	return type;
+}
+
 static struct tep_function_handler *
 find_func_handler(struct tep_handle *tep, char *func_name)
 {
@@ -3484,6 +3498,11 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		free_token(token);
 		return process_bitmask(event, arg, tok);
 	}
+	if (strcmp(token, "__get_cpumask") == 0 ||
+	    strcmp(token, "__get_cpumask") == 0) {
+		free_token(token);
+		return process_cpumask(event, arg, tok);
+	}
 	if (strcmp(token, "__get_dynamic_array") == 0 ||
 	    strcmp(token, "__get_rel_dynamic_array") == 0 ||
 	    strcmp(token, "__get_sockaddr") == 0 ||
@@ -4144,6 +4163,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 	case TEP_PRINT_STRING:
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 		return 0;
 	case TEP_PRINT_FUNC: {
 		struct trace_seq s;
@@ -4637,6 +4657,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
+	case TEP_PRINT_CPUMASK:
 	case TEP_PRINT_BITMASK: {
 		if (!arg->bitmask.field) {
 			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
@@ -7158,6 +7179,9 @@ static void print_args(struct tep_print_arg *args)
 	case TEP_PRINT_BITMASK:
 		printf("__get_bitmask(%s)", args->bitmask.bitmask);
 		break;
+	case TEP_PRINT_CPUMASK:
+		printf("__get_cpumask(%s)", args->bitmask.bitmask);
+		break;
 	case TEP_PRINT_TYPE:
 		printf("(%s)", args->typecast.type);
 		print_args(args->typecast.item);
-- 
2.31.1

