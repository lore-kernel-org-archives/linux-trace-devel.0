Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9864AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 20:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E7DB60F9D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 20:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbhJZUJN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 16:09:13 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.36]:19013 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239090AbhJZUJM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 16:09:12 -0400
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2021 16:09:12 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 4F4786F96
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Oct 2021 14:44:07 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id fSMhmEuNRIWzGfSMhmOUVH; Tue, 26 Oct 2021 14:44:07 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:60828 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mfSMf-001u4r-Pm; Tue, 26 Oct 2021 14:44:06 -0500
Message-ID: <e16ec205-5830-c168-4267-be7bf923f2a9@kernel.org>
Date:   Tue, 26 Oct 2021 21:43:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V5 08/20] rtla: Helper functions for rtla
Content-Language: en-US
To:     Tao Zhou <tao.zhou@linux.dev>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635181938.git.bristot@kernel.org>
 <bc01018cef80ddb95fd0ccf1ec72963be7e4fc19.1635181938.git.bristot@kernel.org>
 <YXgrLIiK8pwOVsBe@geo.homenetwork>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <YXgrLIiK8pwOVsBe@geo.homenetwork>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.18.63.114
X-Source-L: No
X-Exim-ID: 1mfSMf-001u4r-Pm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:60828
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tao

Thanks for your reviews!

On 10/26/21 18:22, Tao Zhou wrote:
> Hi Daniel,
> 
> On Mon, Oct 25, 2021 at 07:40:33PM +0200, Daniel Bristot de Oliveira wrote:
> 
>> This is a set of utils and tracer helper functions. They are used by
>> rtla mostly to parse config, display data and some trace operations that
>> are not part of libtracefs (because they are only useful it for this
>> case).
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Tom Zanussi <zanussi@kernel.org>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Juri Lelli <juri.lelli@redhat.com>
>> Cc: Clark Williams <williams@redhat.com>
>> Cc: John Kacur <jkacur@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
>> Cc: linux-rt-users@vger.kernel.org
>> Cc: linux-trace-devel@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
>> ---
>>  tools/tracing/rtla/src/trace.c | 219 +++++++++++++++++
>>  tools/tracing/rtla/src/trace.h |  27 ++
>>  tools/tracing/rtla/src/utils.c | 433 +++++++++++++++++++++++++++++++++
>>  tools/tracing/rtla/src/utils.h |  56 +++++
>>  4 files changed, 735 insertions(+)
>>  create mode 100644 tools/tracing/rtla/src/trace.c
>>  create mode 100644 tools/tracing/rtla/src/trace.h
>>  create mode 100644 tools/tracing/rtla/src/utils.c
>>  create mode 100644 tools/tracing/rtla/src/utils.h
>>
>> diff --git a/tools/tracing/rtla/src/trace.c b/tools/tracing/rtla/src/trace.c
>> new file mode 100644
>> index 000000000000..0f66e99fef0d
>> --- /dev/null
>> +++ b/tools/tracing/rtla/src/trace.c
>> @@ -0,0 +1,219 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#define _GNU_SOURCE
>> +#include <sys/sendfile.h>
>> +#include <tracefs.h>
>> +#include <signal.h>
>> +#include <stdlib.h>
>> +#include <unistd.h>
>> +#include <errno.h>
>> +
>> +#include "trace.h"
>> +#include "utils.h"
>> +
>> +/*
>> + * enable_tracer_by_name - enable a tracer on the given instance
>> + */
>> +int enable_tracer_by_name(struct tracefs_instance *inst, const char *tracer)
>> +{
>> +	enum tracefs_tracers t;
>> +	int retval;
>> +
>> +	t = TRACEFS_TRACER_CUSTOM;
>> +
>> +	debug_msg("enabling %s tracer\n", tracer);
>> +
>> +	retval = tracefs_tracer_set(inst, t, tracer);
>> +	if (retval < 0) {
>> +		if (errno == ENODEV)
>> +			err_msg("tracer %s not found!\n", tracer);
>> +
>> +		err_msg("failed to enable the tracer %s\n", tracer);
>> +		return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * disable_tracer - set nop tracer to the insta
>> + */
>> +void disable_tracer(struct tracefs_instance *inst)
>> +{
>> +	enum tracefs_tracers t = TRACEFS_TRACER_NOP;
>> +	int retval;
>> +
>> +	retval = tracefs_tracer_set(inst, t);
> 
> Thank you for share. Also not know much about trace..
> Nits below.
> 
> enable_tracer_by_name() call tracefs_tracer_set(inst, t, tracer).
> Is tracefs_tracer_set() called here lack a NULL; like:
> 
>   tracefs_tracer_set(inst, t, NULL)
> 
> Or I am wrong.

I am just following documentation:

https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/tree/Documentation/libtracefs-tracer.txt#n14

>> +	if (retval < 0)
>> +		err_msg("oops, error disabling tracer\n");
>> +}
>> +
>> +/*
>> + * create_instance - create a trace instance with *instance_name
>> + */
>> +struct tracefs_instance *create_instance(char *instance_name)
>> +{
>> +	return tracefs_instance_create(instance_name);
>> +}
>> +
>> +/*
>> + * destroy_instance - remove a trace instance and free the data
>> + */
>> +void destroy_instance(struct tracefs_instance *inst)
>> +{
>> +	tracefs_instance_destroy(inst);
>> +	tracefs_instance_free(inst);
>> +}
>> +
>> +/*
>> + * save_trace_to_file - save the trace output of the instance to the file
>> + */
>> +int save_trace_to_file(struct tracefs_instance *inst, const char *filename)
>> +{
>> +	const char *file = "trace";
>> +	mode_t mode = 0644;
>> +	char *buffer[4096];
>> +	int out_fd, in_fd;
>> +	int retval = -1;
>> +
>> +	in_fd = tracefs_instance_file_open(inst, file, O_RDONLY);
>> +	if (in_fd < 0) {
>> +		err_msg("Failed to open trace file\n");
>> +		return -1;
>> +	}
>> +
>> +	out_fd = creat(filename, mode);
>> +	if (out_fd < 0) {
>> +		err_msg("Failed to create output file %s\n", filename);
>> +		goto out_close;
>> +	}
>> +
>> +	do {
>> +		retval = read(in_fd, buffer, sizeof(buffer));
>> +		if (read <= 0)
> 
> check "retval" not read. Like:
> 
>   if (retval <= 0)


I bet vim's ^p helped on that.... fixing in a new version.

>> +			goto out_close;
>> +
>> +		retval = write(out_fd, buffer, retval);
>> +		if (retval < 0)
>> +			goto out_close;
>> +	} while (retval > 0);
>> +
>> +	retval = 0;
>> +	close(out_fd);
>> +out_close:
> 
> And this out_close: label put before "close(out_fd);". Like:
> 
>   retval = 0;
> out_close:
>   close(out_fd);
>   close(in_fd);


Actually, I need to add another label, one to close onlu in_fd, and another to
close all... anyway, yep, there is an error here.

Thanks
-- Daniel
