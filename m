Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD379C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 08:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C460F60E75
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 08:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhJZJCR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:02:17 -0400
Received: from gateway30.websitewelcome.com ([192.185.193.11]:21342 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230477AbhJZJCQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 05:02:16 -0400
X-Greylist: delayed 1278 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2021 05:02:16 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 4035A15686
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Oct 2021 03:38:33 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id fHybm5r8c6dDyfHybmglAe; Tue, 26 Oct 2021 03:38:33 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:60754 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mfHya-002yuX-0p; Tue, 26 Oct 2021 03:38:32 -0500
Message-ID: <f30262dc-f1cf-4945-5a7d-5ecf5a0b5cc2@kernel.org>
Date:   Tue, 26 Oct 2021 10:38:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V5 06/20] trace/osnoise: Allow multiple instances of the
 same tracer
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
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
 <69cbbd98cce2515c84127c8827d733dc87b04823.1635181938.git.bristot@kernel.org>
 <20211025220856.7fef7581@rorschach.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211025220856.7fef7581@rorschach.local.home>
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
X-Exim-ID: 1mfHya-002yuX-0p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:60754
X-Source-Auth: kernel@bristot.me
X-Email-Count: 15
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/26/21 04:08, Steven Rostedt wrote:
> On Mon, 25 Oct 2021 19:40:31 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>>  kernel/trace/trace_osnoise.c | 101 +++++++++++++++++++++++++++--------
>>  1 file changed, 78 insertions(+), 23 deletions(-)
>>
>> diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
>> index 3db506f49a90..8681ffc3817b 100644
>> --- a/kernel/trace/trace_osnoise.c
>> +++ b/kernel/trace/trace_osnoise.c
>> @@ -64,6 +64,24 @@ static bool osnoise_has_registered_instances(void)
>>  					list);
>>  }
>>  
>> +/*
>> + * osnoise_instance_registered - check if a tr is already registered
>> + */
>> +static int osnoise_instance_registered(struct trace_array *tr)
>> +{
>> +	struct osnoise_instance *inst;
>> +	int found = 0;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(inst, &osnoise_instances, list) {
>> +		if (inst->tr == tr)
>> +			found = 1;
>> +	}
>> +	rcu_read_unlock();
>> +
>> +	return found;
>> +}
>> +
>>  /*
>>   * osnoise_register_instance - register a new trace instance
>>   *
>> @@ -2048,6 +2066,16 @@ static int osnoise_workload_start(void)
>>  {
>>  	int retval;
>>  
>> +	/*
>> +	 * Instances need to be registered after calling workload
>> +	 * start. Hence, if there is already an instance, the
>> +	 * workload was already registered. Otherwise, this
>> +	 * code is on the way to register the first instance,
>> +	 * and the workload will start.
>> +	 */
>> +	if (osnoise_has_registered_instances())
>> +		return 0;
> 
> Looking at how this is checked before being called, it really should
> return -1, as it is an error if this is called with instances active.

Hum.... maybe my explanation is not good enough. It is not a problem if it is
called with active instances. It would be an error if the same instance was
already registered at this point, but that was checked before. Here it is
checking for other instances that should have enabled the workload.

Does updating the comment with the one below helps?

---- %< ----
Instances need to be registered after calling workload
start. Hence, if there is already a registered instance,
this instance is not the first one to enable the workload,
and a previous instance has already started the workload.

Otherwise, this code is on the way to register the
first instance, and the workload needs to start.
---- >% ----

?


> -- Steve
> 
>> +
>>  	osn_var_reset_all();
>>  
>>  	retval = osnoise_hook_events();
>> @@ -2075,6 +2103,13 @@ static int osnoise_workload_start(void)
>>   */
>>  static void osnoise_workload_stop(void)
>>  {
>> +	/*
>> +	 * Instances need to be unregistered before calling
>> +	 * stop. Hence, if there is a registered instance, more
>> +	 * than one instance is running, and the workload will not
>> +	 * yet stop. Otherwise, this code is on the way to disable
>> +	 * the last instance, and the workload can stop.
>> +	 */
>>  	if (osnoise_has_registered_instances())
>>  		return;
>>  
>> @@ -2096,7 +2131,11 @@ static void osnoise_tracer_start(struct trace_array *tr)
>>  {
>>  	int retval;
>>  
>> -	if (osnoise_has_registered_instances())
>> +	/*
>> +	 * If the instance is already registered, there is no need to
>> +	 * register it again.
>> +	 */
>> +	if (osnoise_instance_registered(tr))
>>  		return;
>>  
>>  	retval = osnoise_workload_start();

