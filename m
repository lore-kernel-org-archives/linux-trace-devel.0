Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7814C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 16:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D80B61181
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 16:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhJ2QGH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 12:06:07 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.212]:42478 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhJ2QGH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 12:06:07 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 5BD6B40109D70
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Oct 2021 11:03:38 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id gULymtPYJgm2UgULyml2Vp; Fri, 29 Oct 2021 11:03:38 -0500
X-Authority-Reason: nr=8
Received: from host-79-27-6-113.retail.telecomitalia.it ([79.27.6.113]:40438 helo=[10.0.0.44])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mgULx-001Sy2-2u; Fri, 29 Oct 2021 11:03:37 -0500
Message-ID: <8ba373fa-2649-db63-546d-d300b9205947@kernel.org>
Date:   Fri, 29 Oct 2021 18:03:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V6 09/20] rtla: Add osnoise tool
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
References: <cover.1635284863.git.bristot@kernel.org>
 <a389dec45805f3221fe1a8e86c725ae24d16ec82.1635284863.git.bristot@kernel.org>
 <YXl+krtOjd5CzDRc@geo.homenetwork>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <YXl+krtOjd5CzDRc@geo.homenetwork>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.27.6.113
X-Source-L: No
X-Exim-ID: 1mgULx-001Sy2-2u
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-27-6-113.retail.telecomitalia.it ([10.0.0.44]) [79.27.6.113]:40438
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/27/21 18:30, Tao Zhou wrote:
> On Wed, Oct 27, 2021 at 12:06:20AM +0200, Daniel Bristot de Oliveira wrote:
> 
>> +/*
>> + * osnoise_set_cpus - configure osnoise to run on *cpus
>> + *
>> + * "osnoise/cpus" file is used to set the cpus in which osnoise/timerlat
>> + * will run. This function opens this file, saves the current value,
>> + * and set the cpus passed as argument.
>> + */
>> +int osnoise_set_cpus(struct osnoise_context *context, char *cpus)
>> +{
>> +	char *osnoise_cpus = tracefs_get_tracing_file("osnoise/cpus");
>> +	char curr_cpus[1024];
>> +	int retval;
>> +
>> +	context->cpus_fd = open(osnoise_cpus, O_RDWR);
>> +	if (!context->cpus_fd)
>> +		goto out_err;
> The above check should be "context->cpus_fd < 0".

Revisited all open/read/write!

>> +	retval = read(context->cpus_fd, &curr_cpus, sizeof(curr_cpus));
>> +	if (!retval)
>> +		goto out_close;
>> +	context->orig_cpus = strdup(curr_cpus);
>> +	if (!context->orig_cpus)
>> +		goto out_err;
> Need to close ->cpus_fd;
> 
>   if (!context->orig_cpus)
>     goto out_close;
> 
>> +	retval = write(context->cpus_fd, cpus, strlen(cpus) + 1);
>> +	if (!retval)
>> +		goto out_err;
> Same as above. Use "goto out_close" instead.

yep! fixed in the next version.

>> +	tracefs_put_tracing_file(osnoise_cpus);
>> +
>> +	return 0;
>> +
>> +out_close:
>> +	close(context->cpus_fd);
>> +	context->cpus_fd = -1;
>> +out_err:
>> +	tracefs_put_tracing_file(osnoise_cpus);
>> +	return 1;
>> +}
>> +
>> +/*
>> + * osnoise_restore_cpus - restore the original "osnoise/cpus"
>> + *
>> + * osnoise_set_cpus() saves the original data for the "osnoise/cpus"
>> + * file. This function restore the original config it was previously
>> + * modified.
>> + */
>> +void osnoise_restore_cpus(struct osnoise_context *context)
>> +{
>> +	int retval;
>> +
>> +	if (!context->orig_cpus)
>> +		return;
>> +
>> +	retval = write(context->cpus_fd, context->orig_cpus, strlen(context->orig_cpus));
> __osnoise_write_runtime() check "context->cpus_fd == -1".
> Is it possible here we need to check "context->cpus_fd == -1".
> 

So, yeah, this was inconsistent. In some parts I checked the fd, on other I
checked if the original value was load, so the file was opened. In the next
version I am checking if the original value was loaded, and then using it to
define if the fd is open.

Thanks for your review Tao!
-- Daniel
