Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90466C7EE2E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 May 2023 12:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjE2MGC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 May 2023 08:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjE2MGA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 May 2023 08:06:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19134D9
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 05:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA2061269
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 12:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693A9C433EF;
        Mon, 29 May 2023 12:05:56 +0000 (UTC)
Date:   Mon, 29 May 2023 08:05:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libtracefs: Unit test for
 tracefs_instance_reset()
Message-ID: <20230529080552.2dbfdc9f@rorschach.local.home>
In-Reply-To: <20230426041124.69544-4-tz.stoyanov@gmail.com>
References: <20230426041124.69544-1-tz.stoyanov@gmail.com>
        <20230426041124.69544-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 26 Apr 2023 07:11:24 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static void test_instance_reset(void)
> +{
> +	struct tracefs_instance *instance = NULL;
> +	const char *name = get_rand_str();
> +
> +	CU_TEST(tracefs_instance_exists(name) == false);
> +	instance = tracefs_instance_create(name);
> +	CU_TEST(instance != NULL);
> +
> +	CU_TEST(test_instance_check_default_state(instance) == true);
> +
> +	CU_TEST(tracefs_tracer_set(instance, TRACEFS_TRACER_HWLAT) == 0);
> +	CU_TEST(tracefs_event_enable(instance, "bridge", "fdb_delete") == 0);

Was there a reason why you picked HWLAT tracer and the fdb_delete trace
event? Neither exist in my test machine setup, so this test
automatically fails.

-- Steve


> +	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_pid", "5") > 0);
> +	CU_TEST(tracefs_instance_file_write(instance, "trace_clock", "global") > 0);
> +	CU_TEST(tracefs_instance_file_write(instance, "set_event_pid", "5") > 0);
> +	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_filter",
> +						      "schedule:stacktrace") > 0);
> +	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_notrace",
> +						      "schedule:stacktrace") > 0);
> +	CU_TEST(tracefs_instance_file_write(instance, "tracing_cpumask", "0f") > 0);
> +	CU_TEST(tracefs_instance_file_write(instance, "events/syscalls/sys_exit_read/trigger",
> +						      "enable_event:kmem:kmalloc:1") > 0);
> +	CU_TEST(tracefs_instance_file_write(instance, "events/bridge/fdb_delete/filter",
> +						      "common_pid == 5") > 0);
> +
> +	CU_TEST(test_instance_check_default_state(instance) == false);
> +
> +	tracefs_instance_reset(instance);
> +	CU_TEST(test_instance_check_default_state(instance) == true);
> +
> +	CU_TEST(tracefs_instance_destroy(instance) == 0);
> +	tracefs_instance_free(instance);
> +}
> +
