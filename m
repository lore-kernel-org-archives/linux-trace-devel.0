Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3632C10F1D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Dec 2022 17:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiLMRCY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbiLMRBO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 12:01:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFF324F18
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 08:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670950628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LiZjRFZPyEIQsuTzfYOxj7UrpVMrvcaaOcKi05q53Hw=;
        b=UvCu2DBnIihfPlwHAsZtbCvbJ7zJ5KuzAuxNTC2Aa74bJEPoAwsrQYZxBPlDd83TXBfu2q
        qeujbE1oXz1xVeiMRfhsckXaohiQC6Vyjt1Ptm3QfkkHrYVKE6+ZLQBAB4aGMeF1d01Two
        lY02dd4mFBCAKaUF8OOBC+mt50P0Pds=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-AZFHin3hN66DIRb4NkhO8g-1; Tue, 13 Dec 2022 11:57:07 -0500
X-MC-Unique: AZFHin3hN66DIRb4NkhO8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54EC6803911;
        Tue, 13 Dec 2022 16:57:06 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.33.36.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C4741121319;
        Tue, 13 Dec 2022 16:57:05 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v3 2/4] libtraceevent: Add boiler-plate code for cpumask types
Date:   Tue, 13 Dec 2022 16:56:18 +0000
Message-Id: <20221213165620.1034287-3-vschneid@redhat.com>
In-Reply-To: <20221213165620.1034287-1-vschneid@redhat.com>
References: <20221213165620.1034287-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
index 3be98b0..2171ad7 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -244,6 +244,7 @@ enum tep_print_arg_type {
 	TEP_PRINT_BITMASK,
 	TEP_PRINT_DYNAMIC_ARRAY_LEN,
 	TEP_PRINT_HEX_STR,
+	TEP_PRINT_CPUMASK,
 };
 
 struct tep_print_arg {
diff --git a/src/event-parse.c b/src/event-parse.c
index 093b345..ba8e727 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1120,6 +1120,7 @@ static void free_arg(struct tep_print_arg *arg)
 		free(arg->string.string);
 		break;
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 		free(arg->bitmask.bitmask);
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY:
@@ -2853,6 +2854,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 	case TEP_PRINT_STRING:
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2882,6 +2884,7 @@ static char *arg_eval (struct tep_print_arg *arg)
 	case TEP_PRINT_STRING:
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -3362,6 +3365,17 @@ process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
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
@@ -3521,6 +3535,11 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
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
@@ -4181,6 +4200,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 	case TEP_PRINT_STRING:
 	case TEP_PRINT_BSTRING:
 	case TEP_PRINT_BITMASK:
+	case TEP_PRINT_CPUMASK:
 		return 0;
 	case TEP_PRINT_FUNC: {
 		struct trace_seq s;
@@ -4674,6 +4694,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
+	case TEP_PRINT_CPUMASK:
 	case TEP_PRINT_BITMASK: {
 		if (!arg->bitmask.field) {
 			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
@@ -7196,6 +7217,9 @@ static void print_args(struct tep_print_arg *args)
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

