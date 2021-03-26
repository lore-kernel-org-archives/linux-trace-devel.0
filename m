Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CABC433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8145D61A19
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhCYAYM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhCYAYL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 20:24:11 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045DAC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 17:24:10 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v3so78478pgq.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 17:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=F/Q6l0TvUo3SjMvrmy0nVTXj4q9PiXqklgSbq5/AQ2I=;
        b=l0CLbsmmGR90iz/Y2jBm/5v7CGB3Decn+tFS0JnlChYBpsvSWWu/BbEMZpcVjDGqhD
         uOymATDU+uDiQ+L/pd/OGA4fftKc+cRc3hUyYJXd9EM4RCXb8bZ/RCelTDMfhW7FY3ft
         jkVqXZ5H7atue8OMnQLEiRXOQyWJKljm/Go7ekMtEdk7ucTaYe9MV1kQku94DcLOkEDW
         AcEyyo8krFFEE21SRecjOJGAzQ7yGFSZW/0bBoHaAV7txLGm/vM6qCNv9h7hQwzeAWKF
         BzfjlQBEDLpPwHoAtCLNBQ3o+I+lwLWvI65SiojAtFEs/5kRuF0wt7tvEe8uAKxgSC6M
         AlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=F/Q6l0TvUo3SjMvrmy0nVTXj4q9PiXqklgSbq5/AQ2I=;
        b=qxrOCpRMMzFRFWr4cVCbhTJtIAa7tlpYHYwjIufbtsL2T8QlQMKmb4E7TeyN+3Dauo
         hb4xbjVNX8ZtOrsfrf5Bstc3ylQbCNZTRzAMTlmFVrT1VtXfTe18Th1Q0cT+OwcGpECy
         6+BcVy7NgMhbFbq0P5YbLpm86jCxrQ4mBINZh33M3d8aA0X5pkWJwryZ5pdz0Rni3EgI
         eCmfQL9p2rqRA9hfx1KktvbUcSYr7ra5kamXemXMssIxF1qcJYAok5EYMVXWp3u8Huah
         CjGKlZF0B+ofdljN55kit5kbuGUgHiVUv718VO86vUa6NacR4TMM6YGUWSoZK3cjyd16
         Jd6w==
X-Gm-Message-State: AOAM531kd0lSfCv10kRynOF5RBZiaNoxVnhxXF3tQEirSrlhig4LH2v9
        gen1ClLgUa5vq4wh38cSf0cPzLDPQC/5lg==
X-Google-Smtp-Source: ABdhPJzkcx4aKiTp2lrB9oOL2J1QbsJgliI0YO0HxCZXloyxMcltLjH4BXubAX8ScaSBw1XZ/FyBOQ==
X-Received: by 2002:aa7:969d:0:b029:1f5:b02c:eed3 with SMTP id f29-20020aa7969d0000b02901f5b02ceed3mr5310167pfk.75.1616631850291;
        Wed, 24 Mar 2021 17:24:10 -0700 (PDT)
Received: from [192.168.1.143] ([27.6.175.206])
        by smtp.gmail.com with ESMTPSA id q10sm3264869pgs.44.2021.03.24.17.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 17:24:09 -0700 (PDT)
Subject: Re: [PATCH] libtracefs: Document function_filter API
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
References: <1616689890-18853-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <20210324174007.1de9b157@gandalf.local.home>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <7e976f5b-79ec-3ce7-fb4b-6ec79fcf1298@gmail.com>
Date:   Fri, 26 Mar 2021 05:54:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210324174007.1de9b157@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi steve,

On 25/03/21 3:10 am, Steven Rostedt wrote:
> Hi Sameer!
>
> On Thu, 25 Mar 2021 22:01:30 +0530
> Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
>
>> Added documentation for the below API:
>> tracefs_function_filter()
>>
>> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
>>
>> diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
>> new file mode 100644
>> index 0000000..08eece7
>> --- /dev/null
>> +++ b/Documentation/libtracefs-function-filter.txt
>> @@ -0,0 +1,116 @@
>> +libtracefs(3)
>> +=============
>> +
>> +NAME
>> +----
>> +tracefs_function_filter -  Function to write to set_ftrace_filter
>> +file of specific instance or top tracing instance
> Since we are abstracting out tracefs, I'd like to avoid the implementation
> details, and keep it more about its functionality.
>
>   - Function to limit kernel functions that are traced
>
>> +
>> +SYNOPSIS
>> +--------
>> +[verse]
>> +--
>> +*#include <tracefs.h>*
>> +
>> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
>> +--
>> +
>> +DESCRIPTION
>> +-----------
>> +This Function can be used to write to set_ftrace_file in the trace
>> +filesystem, which will limit the trace to only those functions,
>> +which were written in the file.
> To avoid stating the implementation:
>
> "This function can be used to limit the Linux kernel functions that is
> traced by the function and function-graph tracers."
>
>
>> +
>> +It will take take _instance_argument, that can be NULL for the
>> +top level tracing, _filters_, which is nothing but the array of the
> No need to say "nothing"
>
> "which is an array of strings that represent a list of filters that should
> be applied to define what functions are to be traced. The array must end
> with a NULL pointer."
>
>> +strings to write into the set_ftrace_filter file ,_module_ , name of the
>> +module to be traced, _reset_, to reset or append the filters to file
> "_reset_ if set will clear the current set of filters and then apply the
> filter list, otherwise the list of filters are added to the current set of
> filters."
>
>> + and _errs_ which is again an array of failed filters, which can be NULL
> "and _errs_ is a pointer an array of strings, which will be allocated if
> any of filters fail to any available function. If _errs_ is NULL, it will
> be ignored."
>
>> + if failed filters are not of concern, and  returns 0  on successful write,
>> + 1 or -x (where x is an integer) on error.
> I mentioned in a previous email that I think we need to change the return
> value, but for now this is fine.
In future, when the changes were made, i will change this man page 
accordingly.
>> +
>> +RETURN VALUE
>> +------------
>> +tracefs_function_filter will return 0 on successful write to file, if there
> Just need to say ".. return 0 on success."
>
>> +is error, it will return 1 for general errors or negative number -x(x denotes
>> +number of failed filters), if there are any failed filters.
> Again, I think the error return may be changed, so we can leave this for
> now.
>
>> +
>> +In case of negative return value, errs have to be checked and must be freed
>> +using the free()
>> +
>> +EXAMPLE
>> +-------
>> +[source,c]
>> +--
>> +#include <tracefs.h>
>> +
>> +#define INST "dummy"
>> +
>> +const char *filters[] = { "run_init_process", "try_to_run_init_process", "dummy1", NULL };
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	struct tracefs_instance *inst = tracefs_instance_create(INST);
>> +	const char **errs = NULL;
>> +	bool reset = 1;
>> +	int ret;
>> +	int i = 0;
>> +
>> +	if (!inst) {
>> +	   /* Error creating new trace instance*/
>> +	   }
>> +
>> +	ret = tracefs_function_filter(inst, filters, NULL, reset, &errs);
>> +
>> +	if (ret < 0 && errs) {
>> +	   	while (errs[i])
>> +		      printf("%s\n", errs[i++]);
>> +	      }
>> +
>> +	tracefs_instance_free(inst);
>> +	tracefs_instance_destroy(inst);
>> +	free(errs);
>> +	return 0;
> This looks fine.
>
> Thanks!
>
> -- Steve
>
>> +}
>> +--
>> +
>> +FILES
>> +-----
>> +[verse]
>> +--
>> +*tracefs.h*
>> +	Header file to include in order to have access to the library APIs.
>> +*-ltracefs*
>> +	Linker switch to add when building a program that uses the library.
>> +--
>> +
>> +SEE ALSO
>> +--------
>> +_libtracefs(3)_,
>> +_libtraceevent(3)_,
>> +_trace-cmd(1)_
>> +
>> +AUTHOR
>> +------
>> +[verse]
>> +--
>> +*Steven Rostedt* <rostedt@goodmis.org>
>> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
>> +*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
>> +--
>> +REPORTING BUGS
>> +--------------
>> +Report bugs to  <linux-trace-devel@vger.kernel.org>
>> +
>> +LICENSE
>> +-------
>> +libtracefs is Free Software licensed under the GNU LGPL 2.1
>> +
>> +RESOURCES
>> +---------
>> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>> +
>> +COPYING
>> +-------
>> +Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
>> +the terms of the GNU Public License (GPL).
