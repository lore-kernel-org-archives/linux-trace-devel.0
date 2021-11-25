Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E938EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Nov 2021 14:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355556AbhKYOLx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Nov 2021 09:11:53 -0500
Received: from gateway31.websitewelcome.com ([192.185.144.96]:49947 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355627AbhKYOJw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Nov 2021 09:09:52 -0500
X-Greylist: delayed 1451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2021 09:09:52 EST
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id D1B01FE0807
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Nov 2021 07:42:26 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id qF18m8zbxzWe7qF18mdrNT; Thu, 25 Nov 2021 07:42:26 -0600
X-Authority-Reason: nr=8
Received: from host-79-34-250-122.business.telecomitalia.it ([79.34.250.122]:43160 helo=[10.0.0.34])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mqF17-00375j-GY; Thu, 25 Nov 2021 07:42:25 -0600
Message-ID: <e9f35eec-0001-5259-1096-53730179229d@kernel.org>
Date:   Thu, 25 Nov 2021 14:42:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH V7 02/14] rtla: Helper functions for rtla
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
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
References: <cover.1635535309.git.bristot@kernel.org>
 <1eb27af1d8356d17d1f8a69a362da46ae8594ab0.1635535309.git.bristot@kernel.org>
 <20211124163759.6d118d96@gandalf.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211124163759.6d118d96@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.34.250.122
X-Source-L: No
X-Exim-ID: 1mqF17-00375j-GY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-34-250-122.business.telecomitalia.it ([10.0.0.34]) [79.34.250.122]:43160
X-Source-Auth: kernel@bristot.me
X-Email-Count: 16
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 11/24/21 22:37, Steven Rostedt wrote:
> On Fri, 29 Oct 2021 21:26:05 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
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
> 
> Interesting. We had discussions about having the custom option (which I
> fought for, for this very reason).
> 
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
> 
> Did you really mean to have buffer be 4096 strings?
> 
> Or did you mean:
> 
> 	char buffer[4096];

I should be "char buffer[4096];" I will fix that.

(The * is probably a left over from the idea of using a malloc(4096)...)

-- Daniel


> (i.e. a single string of 4096 size)?
> 
> -- Steve
> 
