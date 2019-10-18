Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A690ECA9EAB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F432222BD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392888AbfJRPUd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:20:33 -0400
Received: from [217.140.110.172] ([217.140.110.172]:42332 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2389421AbfJRPUd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 11:20:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C2DCC8F;
        Fri, 18 Oct 2019 08:20:14 -0700 (PDT)
Received: from [10.1.194.37] (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5BD13F718;
        Fri, 18 Oct 2019 08:20:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] trace-cmd: Check if ftrace file exists, before
 writing in it.
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20191018145759.15335-1-tz.stoyanov@gmail.com>
 <20191018145759.15335-2-tz.stoyanov@gmail.com>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <44cdf0ed-9f00-bee9-35d0-91ac6d6bd2cb@arm.com>
Date:   Fri, 18 Oct 2019 16:20:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191018145759.15335-2-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

On 18/10/2019 15:57, Tzvetomir Stoyanov (VMware) wrote:
> Depending of the kernel configuration, some ftrace files are optional
> and may not exist. This should not confuse trace-cmd, as it is a valid
> case. One such case is tracing_max_latency file, when CONFIG_TRACER_MAX_TRACE
> or CONFIG_HWLAT_TRACER are not set.
> A check is added in write_instance_file() to ensure the file exist before trying
> to write in it.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=205241
> 
> Reported-by: Valentin Schneider <valentin.schneider@arm.com>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Ran through my test just fine, so:

Tested-by: Valentin Schneider <valentin.schneider@arm.com>

Thanks for looking at this!

> ---
>  tracecmd/trace-record.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 81aca1f..c65731f 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -813,11 +813,14 @@ static int
>  write_instance_file(struct buffer_instance *instance,
>  		    const char *file, const char *str, const char *type)
>  {
> +	struct stat st;
>  	char *path;
>  	int ret;
>  
>  	path = get_instance_file(instance, file);
> -	ret = write_file(path, str, type);
> +	ret = stat(path, &st);
> +	if (ret == 0)
> +		ret = write_file(path, str, type);
>  	tracecmd_put_tracing_file(path);
>  
>  	return ret;
> 
