Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90330C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Nov 2022 14:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiKPOnO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 09:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiKPOnN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 09:43:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2E93E0A0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 06:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668609736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTSfZcv0/qr60We+FYe9h91PF39pXr0NSCmVUGdpkqk=;
        b=FxuFxrg09TEav0dd23KlLbJxxEmgzUAX+ejagsQhfZvqF1g9AF9N9xn09brs4OzxZWNbtF
        EV7GpAKhjnhcMelylF98zNhIyDd4Znavx8uyRldZfWQvWtAhisn38ygqJCqhxEdbI2hcYx
        JwFpNBRPzF9UHk58pJ2NmQwozNWmjEg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-GYiEoTQ7NdaOyW6ecnwk4Q-1; Wed, 16 Nov 2022 09:42:07 -0500
X-MC-Unique: GYiEoTQ7NdaOyW6ecnwk4Q-1
Received: by mail-qt1-f198.google.com with SMTP id cj6-20020a05622a258600b003a519d02f59so13007120qtb.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 06:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KTSfZcv0/qr60We+FYe9h91PF39pXr0NSCmVUGdpkqk=;
        b=bRzRVewvGKwBX3H5b27Nit1lxYTLykw/a1j/EF/vHvNOp+/kazy5FZusxDy3JOsim0
         d47RY0LIqUPkejFPAfwQtuhguUi4qW1r5V0fFxvF6xUrGdgK/er86B4OjX46Mav/BkDk
         szN2Uz/azKBQbYsI2svTmUJRE4dhZ0/SpKM/KknlC4VQCIZ6RpgZb4BKH2kKeF2O8+WZ
         VZW+9+JImBjgg76zYpYKUvtOZiH+vsnNRkoDNTIi4Ekh+934PCTHydL+0sfv8Z8OEcmV
         zu+t0GHd2ONkpolbhg2Rt9JtKK2nL+8vfurZ54pMrInJy5D6ZzYuOHl0S1n029ik4T5L
         qF5g==
X-Gm-Message-State: ANoB5pkz690cM/7nyrnArJhV2buxhZUkyRTKq61NICelU2/VYAYO+heG
        hYJNhjDZQKwKrhHUrtp1qhgKfvhwrOFQQcxEoNCYRokq9CTIy+8rUur9sIZLov6dhSQQ4GF+xf0
        bgrn/Mdyq1fF62enM9VBlbetJP/V7JS57OOI81KG6DlGxHvmzIoPwVwtsewFDdcBRjwY392CuzB
        e1shDUJaM=
X-Received: by 2002:ae9:ef12:0:b0:6f4:ae8a:8125 with SMTP id d18-20020ae9ef12000000b006f4ae8a8125mr19839082qkg.522.1668609725719;
        Wed, 16 Nov 2022 06:42:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5WQPHOR/xomsO+addz+jEtUemvrUgtdTNop8MFF3Db/yxXV4IdXCRaR0ozEBkzcMxYi7PFmg==
X-Received: by 2002:ae9:ef12:0:b0:6f4:ae8a:8125 with SMTP id d18-20020ae9ef12000000b006f4ae8a8125mr19839055qkg.522.1668609725376;
        Wed, 16 Nov 2022 06:42:05 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id x12-20020ac8730c000000b003a57f822157sm8707793qto.90.2022.11.16.06.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 06:42:04 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v2 1/2] libtraceevent: Add boiler-plate code for cpumask types
Date:   Wed, 16 Nov 2022 14:41:53 +0000
Message-Id: <20221116144154.3662923-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221116144154.3662923-1-vschneid@redhat.com>
References: <20221116144154.3662923-1-vschneid@redhat.com>
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
index d842f9d..f447708 100644
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
+	    strcmp(token, "__get_rel_cpumask") == 0) {
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

