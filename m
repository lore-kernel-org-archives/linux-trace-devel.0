Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF75C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 08:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7413861C73
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 08:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhGGIOv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 04:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhGGIOv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 04:14:51 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4673CC061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 01:12:10 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h2so2246696edt.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 01:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1QM7bMPmw2c6oOuoiBRhJE0ZlMiOoK1O6BSzWQFOatQ=;
        b=bwEZEY/gDWLPXi5mZ6ssdDQRlROM0iPFn2vGMgr6Zkse4vFPLrXBKRlsPBnt4TIj17
         bVb3F+wKXE+96hyZtOCiRx3eRInCGuI7gc9OW4/xGRsOtbvbfsR833Zt7CfqdNkjpwYI
         rakubbDSk11PIkSiQl8uN+fn15eby8wrlVNlfd62xxgFTLRzKZR5TDCkmgRm+4Aupgxr
         49Q29/aAwHUQJCoIl8Ae85QY8IvD3rjGutylNq+nPKVsfYFQi7LGuHD5UyndIDuCTI3n
         l8W+eugMNgxztEINPkEb7nU5EIyC6DfoMeNBsVWBiNejTjXRbimLzMJyo77SFqeD2bop
         Mi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1QM7bMPmw2c6oOuoiBRhJE0ZlMiOoK1O6BSzWQFOatQ=;
        b=CcDxwJ4SxTRIzNr3rYuF69DQ7EDTFmQxCq2vEofNwXJyx0kyf3plDjzOsmbpFhcjp3
         Ed7VhHUEI84DC/+Q2B3HolnYLt7MfA5GWRH3Pte6CssqysYDmFoRzznjdcdPB/Py2dwm
         hSFM+CZfQefWCxKDqrHbF2m4KtGrx24emypCNIyN8qB4yejE4YBbkZ2XJWKIWfs5Kx6P
         njM64aR33IV/fEmn88IRZVqlYSJ5hs1oEGKwmv++OTH/5lubmv4vjvYFTyODsGYHCoEb
         QaI4tX0WV36TPa63q5ptXuNCBK9sl/Sag1dNDNr1HbgIJkPFiNk0JfzG59q5TdJbYw0X
         yIUw==
X-Gm-Message-State: AOAM5300dColBRrGsE8Xbo8ykbkBDId3C19eiw64iEVWGOdoUK7yBNN4
        Tia0EhlWC+ZnQqzQXGXDmQw=
X-Google-Smtp-Source: ABdhPJzGZZYlRExcr8Adkir7fkDOrJCC+tXTz5w8udsmK5vI8oKkdN5vLOK5784I33UiqVGGDKt7nw==
X-Received: by 2002:aa7:db93:: with SMTP id u19mr28308332edt.227.1625645528828;
        Wed, 07 Jul 2021 01:12:08 -0700 (PDT)
Received: from [192.168.0.109] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id l26sm8556756edt.40.2021.07.07.01.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 01:12:08 -0700 (PDT)
Subject: Re: [PATCH 4/4] libtracefs: Implement API to create / modify and
 display histograms
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
References: <20210707031110.249759-1-rostedt@goodmis.org>
 <20210707031110.249759-5-rostedt@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <0707117e-119a-c7b6-ee1e-ef57e49917ad@gmail.com>
Date:   Wed, 7 Jul 2021 11:12:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707031110.249759-5-rostedt@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On 7.07.21 г. 6:11, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Add an API to facilitate the modification of histograms in ftrace:
> 
>    tracefs_hist_alloc()
>    tracefs_hist_add_key()
>    tracefs_hist_add_value()
>    tracefs_hist_add_name()
>    tracefs_hist_start()
>    tracefs_hist_pause()
>    tracefs_hist_continue()
>    tracefs_hist_reset()
>    tracefs_hist_delete()
>    tracefs_hist_add_sort_key()
>    tracefs_hist_sort_key_direction()
> 
> The above functions can create a tracefs_hist descriptor that can
> facilitate the creation and modification of ftrace event histograms.
> 
> Cc: Tom Zanussi <zanussi@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   Documentation/libtracefs-hist-cont.txt | 192 +++++++++
>   Documentation/libtracefs-hist.txt      | 290 ++++++++++++++
>   include/tracefs.h                      |  46 +++
>   src/Makefile                           |   1 +
>   src/tracefs-hist.c                     | 529 +++++++++++++++++++++++++
>   5 files changed, 1058 insertions(+)
>   create mode 100644 Documentation/libtracefs-hist-cont.txt
>   create mode 100644 Documentation/libtracefs-hist.txt
>   create mode 100644 src/tracefs-hist.c
> 
> diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
> new file mode 100644
> index 000000000000..1b0153c19481
> --- /dev/null
> +++ b/Documentation/libtracefs-hist-cont.txt
> @@ -0,0 +1,192 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_hist_pause, tracefs_hist_continue, tracefs_hist_reset - Pause, continue, or clear an existing histogram
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +int tracefs_hist_pause(struct tracefs_hist pass:[*]hist);
> +int tracefs_hist_continue(struct tracefs_hist pass:[*]hist);
> +int tracefs_hist_reset(struct tracefs_hist pass:[*]hist);
> +--
> +
> +DESCRIPTION
> +-----------
> +*tracefs_hist_pause* is called to pause the histogram _hist_.
> +
> +*tracefs_hist_continue* is called to continue a paused histogram _hist_.
> +
> +*tracefs_hist_reset* is called to clear / reset the histogram _hist_.
> +
> +RETURN VALUE
> +------------
> +All the return zero on success or -1 on error.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <stdlib.h>
> +#include <tracefs/tracefs.h>
> +
> +enum commands {
> +	START,
> +	PAUSE,
> +	CONT,
> +	RESET,
> +	DELETE,
> +	SHOW,
> +};
> +
> +int main (int argc, char **argv, char **env)
> +{
> +	struct tracefs_instance *instance;
> +	struct tracefs_hist *hist;
> +	enum commands cmd;
> +	char *cmd_str;
> +	int ret;
> +
> +	if (argc < 2) {
> +		fprintf(stderr, "usage: %s command\n", argv[0]);
> +		exit(-1);
> +	}
> +
> +	cmd_str = argv[1];
> +
> +	if (!strcmp(cmd_str, "start"))
> +		cmd = START;
> +	else if (!strcmp(cmd_str, "pause"))
> +		cmd = PAUSE;
> +	else if (!strcmp(cmd_str, "cont"))
> +		cmd = CONT;
> +	else if (!strcmp(cmd_str, "reset"))
> +		cmd = RESET;
> +	else if (!strcmp(cmd_str, "delete"))
> +		cmd = DELETE;
> +	else if (!strcmp(cmd_str, "show"))
> +		cmd = SHOW;
> +	else {
> +		fprintf(stderr, "Unknown command %s\n", cmd_str);
> +		exit(-1);
> +	}
> +

I see no reason to ask the user to implement this logic.
This can be part of the library.


> +	instance = tracefs_instance_create("hist_test");
> +	if (!instance) {
> +		fprintf(stderr, "Failed instance create\n");
> +		exit(-1);
> +	}
> +
> +	hist = tracefs_hist_alloc(instance, "kmem", "kmalloc",
> +				  "call_site", TRACEFS_HIST_KEY_SYM);
> +	if (!hist) {
> +		fprintf(stderr, "Failed hist create\n");
> +		exit(-1);
> +	}
> +
> +	ret = tracefs_hist_add_key(hist, "bytes_req", 0);
> +	ret |= tracefs_hist_add_value(hist, "bytes_alloc");
> +	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
> +
> +	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
> +					       TRACEFS_HIST_SORT_DESCENDING);
> +	if (ret) {
> +		fprintf(stderr, "Failed modifying histogram\n");
> +		exit(-1);
> +	}
> +
> +	tracefs_error_clear(instance);
> +
> +	switch (cmd) {
> +	case START:
> +		ret = tracefs_hist_start(hist);
> +		if (ret) {
> +			char *err = tracefs_error_last(instance);
> +			if (err)
> +				fprintf(stderr, "\n%s\n", err);
> +		}
> +		break;
> +	case PAUSE:
> +		ret = tracefs_hist_pause(hist);
> +		break;
> +	case CONT:
> +		ret = tracefs_hist_continue(hist);
> +		break;
> +	case RESET:
> +		ret = tracefs_hist_reset(hist);
> +		break;
> +	case DELETE:
> +		ret = tracefs_hist_destroy(hist);
> +		break;
> +	case SHOW: {
> +		char *content;
> +		content = tracefs_event_file_read(instance, "kmem", "kmalloc",
> +						  "hist", NULL);

It looks more intuitive to have

char *tracefs_hist_read(struct tracefs_hist *hist)

> +		ret = content ? 0 : -1;
> +		if (content) {
> +			printf("%s\n", content);
> +			free(content);
> +		}
> +		break;
> +	}
> +	}

This "switch" can move to the library as well.
We can have a method

int tracefs_hist_ctrl(struct tracefs_hist *hist,
		      const char *cmd,
		      void *output);

Thanks!
Yordan



> +	if (ret)
> +		fprintf(stderr, "Failed: command\n");
> +	exit(ret);
> +}
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*tracefs.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltracefs*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtracefs(3)_,
> +_libtraceevent(3)_,
> +_trace-cmd(1)_,
> +_tracefs_hist_alloc(3)_,
> +_tracefs_hist_free(3)_,
> +_tracefs_hist_add_key(3)_,
> +_tracefs_hist_add_value(3)_,
> +_tracefs_hist_add_name(3)_,
> +_tracefs_hist_start(3)_,
> +_tracefs_hist_destory(3)_,
> +_tracefs_hist_add_sort_key(3)_,
> +_tracefs_hist_sort_key_direction(3)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
> +*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtracefs is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> +
> +COPYING
> +-------
> +Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
> +the terms of the GNU Public License (GPL).
> diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
> new file mode 100644
> index 000000000000..67b2a068ac45
> --- /dev/null
> +++ b/Documentation/libtracefs-hist.txt
> @@ -0,0 +1,290 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
> +tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_sort_key_direction - Create and update event histograms
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_instance pass:[*] instance,
> +			const char pass:[*]system, const char pass:[*]event,
> +			const char pass:[*]key, enum tracefs_hist_key_type type);
> +void tracefs_hist_free(struct tracefs_hist pass:[*]hist);
> +int tracefs_hist_add_key(struct tracefs_hist pass:[*]hist, const char pass:[*]key,
> +			 enum tracefs_hist_key_type type);
> +int tracefs_hist_add_value(struct tracefs_hist pass:[*]hist, const char pass:[*]value);
> +int tracefs_hist_add_sort_key(struct tracefs_hist pass:[*]hist,
> +			      const char pass:[*]sort_key, ...);
> +int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
> +				    const char pass:[*]sort_key,
> +				    enum tracefs_hist_sort_direction dir);
> +int tracefs_hist_add_name(struct tracefs_hist pass:[*]hist, const char pass:[*]name);
> +int tracefs_hist_start(struct tracefs_hist pass:[*]hist);
> +int tracefs_hist_destory(struct tracefs_hist pass:[*]hist);
> +--
> +
> +DESCRIPTION
> +-----------
> +Event histograms are created by the trigger file in the event directory.
> +The syntax can be complex and difficult to get correct. This API handles the
> +syntax, and facilitates the creation and interaction with the event histograms.
> +See https://www.kernel.org/doc/html/latest/trace/histogram.html for more information.
> +
> +*tracefs_hist_alloc*() allocates a "struct tracefs_hist" descriptor and returns
> +the address of it. This descriptor must be freed by *tracefs_hist_free*().
> +The _instance_ is the instance that contains the event that the histogram will be
> +attached to. The _system_ is the system or group of the event. The _event_ is the event
> +to attach the histogram to. The _key_ is a field of the event that will be used as
> +the key of the histogram. The _type_ is the type of the _key_. See KEY TYPES below.
> +
> +*tracefs_hist_free*() frees the _tracefs_hist_ descriptor. Note, it does not stop
> +or disable the running histogram if it was started. *tracefs_hist_destroy*() needs
> +to be called to do so.
> +
> +*tracefs_hist_add_key*() Adds a secondary or tertiary key to the histogram.
> +The key passed to *tracefs_hist_alloc*() is the primary key of the histogram.
> +The first time this function is called, it will add a secondary key (or two dimensional
> +histogram). If this function is called again on the same histogram, it will add
> +a _tertiary_ key (or three dimensional histogram). The _hist_ parameter is the
> +histrogram descriptor to add the _key_ to. The _type_ is the type of key to add
> +(See KEY TYPES below).
> +
> +*tracefs_hist_add_value*() will add a value to record. By default, the value is
> +simply the "hitcount" of the number of times a instance of the histogram's
> +key was hit. The _hist_ is the histogram descriptor to add the value to.
> +The _value_ is a field in the histogram to add to when an instane of the
> +key is hit.
> +
> +*tracefs_hist_add_sort_key*() will add a key to sort on. Th _hist_ is the
> +the histrogram descriptor to add the sort key to. The _sort_key_ is a string
> +that must match either an already defined key of the histogram, or an already
> +defined value. Multiple sort keys may be added to denote a secondary, sort order
> +and so on, but all sort keys must match an existing key or value, or be
> +TRACEFS_HIST_HITCOUNT. The last parameter of *tracefs_hist_add_sort_key*() must
> +be NULL.
> +
> +*tracefs_hist_sort_key_direction*() allows to change the direction of an
> +existing sort key of _hist_. The _sort_key_ is the sort key to change, and
> +_dir_ can be either TRACEFS_HIST_SORT_ASCENDING or TRACEFS_HIST_SORT_DESCENDING,
> +to make the direction of the sort key either ascending or descending respectively.
> +
> +*tracefs_hist_add_name*() adds a name to a histogram. A histogram may be
> +named and if the name matches between more than one event, and they have
> +compatible keys, the multiple histograms with the same name will be merged
> +into a single histogram (shown by either event's hist file). The _hist_
> +is the histogram to name, and the _name_ is the name to give it.
> +
> +*tracefs_hist_start* is called to actually start the histogram _hist_.
> +
> +*tracefs_hist_pause* is called to pause the histogram _hist_.
> +
> +*tracefs_hist_continue* is called to continue a paused histogram _hist_.
> +
> +*tracefs_hist_reset* is called to clear / reset the histogram _hist_.
> +
> +*tracefs_hist_destory* is called to delete the histogram where it will no longer
> +exist.
> +
> +
> +KEY TYPES
> +---------
> +
> +*tracefs_hist_alloc*() and *tracefs_hist_add_key*() both add a key and requires
> +that key to have a type. The types may be:
> +
> + *TRACEFS_HIST_KEY_NORMAL* or zero (0) which is to not modify the type.
> +
> + *TRACEFS_HIST_KEY_HEX* to display the key in hex.
> +
> + *TRACEFS_HIST_KEY_SYM* to display the key as a kernel symbol (if found). If
> +the key is an address, this is useful as it will display the function names instead
> +of just a number.
> +
> + *TRACEFS_HIST_KEY_SYM_OFFSET* similar to *TRACEFS_HIST_KEY_SYM* but will also include
> +the offset of the function to match the exact address.
> +
> +*TRACEFS_HIST_KEY_SYSCALL* If the key is a system call "id" (the number passed from user
> +space to the kernel to tell it what system call it is calling), then the name of
> +the system call is displayed.
> +
> +*TRACEFS_HIST_KEY_EXECNAME* If "common_pid" is the key (the pid of the executing task),
> +instead of showing the number, show the name of the running task.
> +
> +*TRACEFS_HIST_KEY_LOG* will display the key in a binary logarithmic scale.
> +
> +*TRACEFS_HIST_KEY_USECS* for use with "common_timestamp" or TRACEFS_HIST_TIMESTAMP,
> +in which case it will show the timestamp in microseconds instead of nanoseconds.
> +
> +
> +RETURN VALUE
> +------------
> +*tracefs_hist_alloc*() returns an allocated histogram descriptor which must
> +be freed by *tracefs_hist_free*() or NULL on error.
> +
> +All the other functions return zero on success or -1 on error.
> +
> +If *tracefs_hist_start*() returns an error, a message may be displayed
> +in the kernel that can be retrieved by *tracefs_error_last()*.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <stdlib.h>
> +#include <tracefs/tracefs.h>
> +
> +enum commands {
> +	START,
> +	PAUSE,
> +	CONT,
> +	RESET,
> +	DELETE,
> +	SHOW,
> +};
> +
> +int main (int argc, char **argv, char **env)
> +{
> +	struct tracefs_instance *instance;
> +	struct tracefs_hist *hist;
> +	enum commands cmd;
> +	char *cmd_str;
> +	int ret;
> +
> +	if (argc < 2) {
> +		fprintf(stderr, "usage: %s command\n", argv[0]);
> +		exit(-1);
> +	}
> +
> +	cmd_str = argv[1];
> +
> +	if (!strcmp(cmd_str, "start"))
> +		cmd = START;
> +	else if (!strcmp(cmd_str, "pause"))
> +		cmd = PAUSE;
> +	else if (!strcmp(cmd_str, "cont"))
> +		cmd = CONT;
> +	else if (!strcmp(cmd_str, "reset"))
> +		cmd = RESET;
> +	else if (!strcmp(cmd_str, "delete"))
> +		cmd = DELETE;
> +	else if (!strcmp(cmd_str, "show"))
> +		cmd = SHOW;
> +	else {
> +		fprintf(stderr, "Unknown command %s\n", cmd_str);
> +		exit(-1);
> +	}
> +
> +	instance = tracefs_instance_create("hist_test");
> +	if (!instance) {
> +		fprintf(stderr, "Failed instance create\n");
> +		exit(-1);
> +	}
> +
> +	hist = tracefs_hist_alloc(instance, "kmem", "kmalloc",
> +				  "call_site", TRACEFS_HIST_KEY_SYM);
> +	if (!hist) {
> +		fprintf(stderr, "Failed hist create\n");
> +		exit(-1);
> +	}
> +
> +	ret = tracefs_hist_add_key(hist, "bytes_req", 0);
> +	ret |= tracefs_hist_add_value(hist, "bytes_alloc");
> +	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
> +
> +	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
> +					       TRACEFS_HIST_SORT_DESCENDING);
> +	if (ret) {
> +		fprintf(stderr, "Failed modifying histogram\n");
> +		exit(-1);
> +	}
> +
> +	tracefs_error_clear(instance);
> +
> +	switch (cmd) {
> +	case START:
> +		ret = tracefs_hist_start(hist);
> +		if (ret) {
> +			char *err = tracefs_error_last(instance);
> +			if (err)
> +				fprintf(stderr, "\n%s\n", err);
> +		}
> +		break;
> +	case PAUSE:
> +		ret = tracefs_hist_pause(hist);
> +		break;
> +	case CONT:
> +		ret = tracefs_hist_continue(hist);
> +		break;
> +	case RESET:
> +		ret = tracefs_hist_reset(hist);
> +		break;
> +	case DELETE:
> +		ret = tracefs_hist_destroy(hist);
> +		break;
> +	case SHOW: {
> +		char *content;
> +		content = tracefs_event_file_read(instance, "kmem", "kmalloc",
> +						  "hist", NULL);
> +		ret = content ? 0 : -1;
> +		if (content) {
> +			printf("%s\n", content);
> +			free(content);
> +		}
> +		break;
> +	}
> +	}
> +	if (ret)
> +		fprintf(stderr, "Failed: command\n");
> +	exit(ret);
> +}
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*tracefs.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltracefs*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtracefs(3)_,
> +_libtraceevent(3)_,
> +_trace-cmd(1)_,
> +_tracefs_hist_pause(3)_,
> +_tracefs_hist_continue(3)_,
> +_tracefs_hist_reset(3)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
> +*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtracefs is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> +
> +COPYING
> +-------
> +Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
> +the terms of the GNU Public License (GPL).
> diff --git a/include/tracefs.h b/include/tracefs.h
> index afbfd4eb01d6..7e1927b078d3 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -253,4 +253,50 @@ enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *even
>   					     char **type, char **addr, char **format);
>   int tracefs_kprobe_clear_all(bool force);
>   int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
> +
> +enum tracefs_hist_key_type {
> +	TRACEFS_HIST_KEY_NORMAL = 0,
> +	TRACEFS_HIST_KEY_HEX,
> +	TRACEFS_HIST_KEY_SYM,
> +	TRACEFS_HIST_KEY_SYM_OFFSET,
> +	TRACEFS_HIST_KEY_SYSCALL,
> +	TRACEFS_HIST_KEY_EXECNAME,
> +	TRACEFS_HIST_KEY_LOG,
> +	TRACEFS_HIST_KEY_USECS,
> +};
> +
> +enum tracefs_hist_sort_direction {
> +	TRACEFS_HIST_SORT_ASCENDING,
> +	TRACEFS_HIST_SORT_DESCENDING,
> +};
> +
> +#define TRACEFS_HIST_TIMESTAMP		"common_timestamp"
> +#define TRACEFS_HIST_TIMESTAMP_USECS	"common_timestamp.usecs"
> +#define TRACEFS_HIST_CPU		"cpu"
> +
> +#define TRACEFS_HIST_HITCOUNT		"hitcount"
> +
> +struct tracefs_hist;
> +
> +void tracefs_hist_free
> +(struct tracefs_hist *hist);
> +struct tracefs_hist *
> +tracefs_hist_alloc(struct tracefs_instance * instance,
> +		       const char *system, const char *event,
> +		       const char *key, enum tracefs_hist_key_type type);
> +int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
> +			 enum tracefs_hist_key_type type);
> +int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
> +int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> +			      const char *sort_key, ...);
> +int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
> +				    const char *sort_key,
> +				    enum tracefs_hist_sort_direction dir);
> +int tracefs_hist_add_name(struct tracefs_hist *hist, const char *name);
> +int tracefs_hist_start(struct tracefs_hist *hist);
> +int tracefs_hist_pause(struct tracefs_hist *hist);
> +int tracefs_hist_continue(struct tracefs_hist *hist);
> +int tracefs_hist_reset(struct tracefs_hist *hist);
> +int tracefs_hist_destroy(struct tracefs_hist *hist);
> +
>   #endif /* _TRACE_FS_H */
> diff --git a/src/Makefile b/src/Makefile
> index 0697a047f4bc..c7f7c1cc1680 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -9,6 +9,7 @@ OBJS += tracefs-events.o
>   OBJS += tracefs-tools.o
>   OBJS += tracefs-marker.o
>   OBJS += tracefs-kprobes.o
> +OBJS += tracefs-hist.o
>   
>   OBJS := $(OBJS:%.o=$(bdir)/%.o)
>   DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> new file mode 100644
> index 000000000000..9031a77eba4b
> --- /dev/null
> +++ b/src/tracefs-hist.c
> @@ -0,0 +1,529 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
> + *
> + * Updates:
> + * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <dirent.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +
> +#include "tracefs.h"
> +#include "tracefs-local.h"
> +
> +#define HIST_FILE "hist"
> +
> +#define ASCENDING ".ascending"
> +#define DESCENDING ".descending"
> +
> +struct tracefs_hist {
> +	struct tracefs_instance *instance;
> +	char			*system;
> +	char			*event;
> +	char			*name;
> +	char			**keys;
> +	char			**values;
> +	char			**sort;
> +	char			*filter;
> +	int			size;
> +};
> +
> +enum tracefs_hist_command {
> +	HIST_CMD_NONE = 0,
> +	HIST_CMD_PAUSE,
> +	HIST_CMD_CONT,
> +	HIST_CMD_CLEAR,
> +	HIST_CMD_DESTROY,
> +};
> +
> +static void add_list(struct trace_seq *seq, const char *start,
> +		     char **list)
> +{
> +	int i;
> +
> +	trace_seq_puts(seq, start);
> +	for (i = 0; list[i]; i++) {
> +		if (i)
> +			trace_seq_putc(seq, ',');
> +		trace_seq_puts(seq, list[i]);
> +	}
> +}
> +
> +/*
> + * trace_hist_start - Create and start a histogram for an event
> + * @hist: The histogram to write into the trigger file
> + * @command: If not zero, can pause, continue or clear the histogram
> + *
> + * This creates a histogram for an event with the given fields.
> + *
> + * Returns 0 on succes -1 on error.
> + */
> +static int
> +trace_hist_start(struct tracefs_hist *hist,
> +		 enum tracefs_hist_command command)
> +{
> +	struct tracefs_instance *instance = hist->instance;
> +	const char *system = hist->system;
> +	const char *event = hist->event;
> +	struct trace_seq seq;
> +	int ret;
> +
> +	errno = -EINVAL;
> +	if (!hist->keys)
> +		return -1;
> +
> +	trace_seq_init(&seq);
> +
> +	if (command == HIST_CMD_DESTROY)
> +		trace_seq_putc(&seq, '!');
> +
> +	add_list(&seq, "hist:keys=", hist->keys);
> +
> +	if (hist->values)
> +		add_list(&seq, ":vals=", hist->values);
> +
> +	if (hist->sort)
> +		add_list(&seq, ":sort=", hist->sort);
> +
> +	if (hist->size)
> +		trace_seq_printf(&seq, ":size=%d", hist->size);
> +
> +	switch(command) {
> +	case HIST_CMD_NONE: break;
> +	case HIST_CMD_PAUSE: trace_seq_puts(&seq, ":pause"); break;
> +	case HIST_CMD_CONT: trace_seq_puts(&seq, ":cont"); break;
> +	case HIST_CMD_CLEAR: trace_seq_puts(&seq, ":clear"); break;
> +	default: break;
> +	}
> +
> +	if (hist->name)
> +		trace_seq_printf(&seq, ":name=%s", hist->name);
> +
> +	if (hist->filter)
> +		trace_seq_printf(&seq, " if %s\n", hist->filter);
> +
> +	trace_seq_terminate(&seq);
> +
> +	ret = -1;
> +	if (seq.state == TRACE_SEQ__GOOD)
> +		ret = tracefs_event_file_append(instance, system, event,
> +						"trigger", seq.buffer);
> +
> +	trace_seq_destroy(&seq);
> +
> +	return ret < 0 ? -1 : 0;
> +}
> +
> +/**
> + * tracefs_hist_free - free a tracefs_hist element
> + * @hist: The histogram to free
> + */
> +void tracefs_hist_free(struct tracefs_hist *hist)
> +{
> +	if (!hist)
> +		return;
> +
> +	trace_put_instance(hist->instance);
> +	free(hist->system);
> +	free(hist->event);
> +	free(hist->name);
> +	free(hist->filter);
> +	tracefs_list_free(hist->keys);
> +	tracefs_list_free(hist->values);
> +	tracefs_list_free(hist->sort);
> +	free(hist);
> +}
> +
> +/**
> + * tracefs_hist_alloc - Initialize a histogram
> + * @instance: The instance the histogram will be in (NULL for toplevel)
> + * @system: The system the histogram event is in.
> + * @event: The event that the histogram will be attached to.
> + * @key: The primary key the histogram will use
> + * @type: The format type of the key.
> + *
> + * Will initialize a histogram descriptor that will be attached to
> + * the @system/@event with the given @key as the primary. This only
> + * initializes the descriptor, it does not start the histogram
> + * in the kernel.
> + *
> + * Returns an initialized histogram on success.
> + * NULL on failure.
> + */
> +struct tracefs_hist *
> +tracefs_hist_alloc(struct tracefs_instance * instance,
> +			const char *system, const char *event,
> +			const char *key, enum tracefs_hist_key_type type)
> +{
> +	struct tracefs_hist *hist;
> +	int ret;
> +
> +	if (!system || !event || !key)
> +		return NULL;
> +
> +	if (!tracefs_event_file_exists(instance, system, event, HIST_FILE))
> +		return NULL;
> +
> +	hist = calloc(1, sizeof(*hist));
> +	if (!hist)
> +		return NULL;
> +
> +	ret = trace_get_instance(instance);
> +	if (ret < 0) {
> +		free(hist);
> +		return NULL;
> +	}
> +
> +	hist->instance = instance;
> +
> +	hist->system = strdup(system);
> +	hist->event = strdup(event);
> +
> +	ret = tracefs_hist_add_key(hist, key, type);
> +
> +	if (!hist->system || !hist->event || ret < 0) {
> +		tracefs_hist_free(hist);
> +		return NULL;
> +	}
> +
> +
> +	return hist;
> +}
> +
> +/**
> + * tracefs_hist_add_key - add to a key to a histogram
> + * @hist: The histogram to add the key to.
> + * @key: The name of the key field.
> + * @type: The type of the key format.
> + *
> + * This adds a secondary or tertiary key to the histogram.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
> +			 enum tracefs_hist_key_type type)
> +{
> +	bool use_key = false;
> +	char *key_type = NULL;
> +	char **new_list;
> +	int ret;
> +
> +	switch (type) {
> +	case TRACEFS_HIST_KEY_NORMAL:
> +		use_key = true;
> +		ret = 0;
> +		break;
> +	case TRACEFS_HIST_KEY_HEX:
> +		ret = asprintf(&key_type, "%s.hex", key);
> +		break;
> +	case TRACEFS_HIST_KEY_SYM:
> +		ret = asprintf(&key_type, "%s.sym", key);
> +		break;
> +	case TRACEFS_HIST_KEY_SYM_OFFSET:
> +		ret = asprintf(&key_type, "%s.sym-offset", key);
> +		break;
> +	case TRACEFS_HIST_KEY_SYSCALL:
> +		ret = asprintf(&key_type, "%s.syscall", key);
> +		break;
> +	case TRACEFS_HIST_KEY_EXECNAME:
> +		ret = asprintf(&key_type, "%s.execname", key);
> +		break;
> +	case TRACEFS_HIST_KEY_LOG:
> +		ret = asprintf(&key_type, "%s.log2", key);
> +		break;
> +	case TRACEFS_HIST_KEY_USECS:
> +		ret = asprintf(&key_type, "%s.usecs", key);
> +		break;
> +	}
> +
> +	if (ret < 0)
> +		return -1;
> +
> +	new_list = tracefs_list_add(hist->keys, use_key ? key : key_type);
> +	free(key_type);
> +	if (!new_list)
> +		return -1;
> +
> +	hist->keys = new_list;
> +
> +	return 0;
> +}
> +
> +/**
> + * tracefs_hist_add_value - add to a value to a histogram
> + * @hist: The histogram to add the value to.
> + * @key: The name of the value field.
> + *
> + * This adds a value field to the histogram.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value)
> +{
> +	char **new_list;
> +
> +	new_list = tracefs_list_add(hist->values, value);
> +	if (!new_list)
> +		return -1;
> +
> +	hist->values = new_list;
> +
> +	return 0;
> +}
> +
> +/**
> + * tracefs_hist_add_name - name a histogram
> + * @hist: The histogram to name.
> + * @name: The name of the histogram.
> + *
> + * Adds a name to the histogram. Named histograms will share their
> + * data with other events that have the same name as if it was
> + * a single histogram.
> + *
> + * If the histogram already has a name, this will fail.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_add_name(struct tracefs_hist *hist, const char *name)
> +{
> +	if (hist->name)
> +		return -1;
> +
> +	hist->name = strdup(name);
> +
> +	return hist->name ? 0 : -1;
> +}
> +
> +/**
> + * tracefs_hist_start - enable a histogram
> + * @hist: The histogram to start
> + *
> + * Starts executing a histogram.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_start(struct tracefs_hist *hist)
> +{
> +	return trace_hist_start(hist, 0);
> +}
> +
> +/**
> + * tracefs_hist_pause - pause a histogram
> + * @hist: The histogram to pause
> + *
> + * Pause a histogram.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_pause(struct tracefs_hist *hist)
> +{
> +	return trace_hist_start(hist, HIST_CMD_PAUSE);
> +}
> +
> +/**
> + * tracefs_hist_continue - continue a paused histogram
> + * @hist: The histogram to continue
> + *
> + * Continue a histogram.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_continue(struct tracefs_hist *hist)
> +{
> +	return trace_hist_start(hist, HIST_CMD_CONT);
> +}
> +
> +/**
> + * tracefs_hist_reset - clear a histogram
> + * @hist: The histogram to reset
> + *
> + * Resets a histogram.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_reset(struct tracefs_hist *hist)
> +{
> +	return trace_hist_start(hist, HIST_CMD_CLEAR);
> +}
> +
> +/**
> + * tracefs_hist_destroy - deletes a histogram (needs to be enabled again)
> + * @hist: The histogram to delete
> + *
> + * Deletes (removes) a running histogram. This is different than
> + * clear, as clear only clears the data but the histogram still exists.
> + * This deletes the histogram and should be called before
> + * tracefs_hist_free() to clean up properly.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_destroy(struct tracefs_hist *hist)
> +{
> +	return trace_hist_start(hist, HIST_CMD_DESTROY);
> +}
> +
> +static char **
> +add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
> +{
> +	char **key_list = hist->keys;
> +	char **val_list = hist->values;
> +	int i;
> +
> +	if (strcmp(sort_key, TRACEFS_HIST_HITCOUNT) == 0)
> +		goto out;
> +
> +	for (i = 0; key_list[i]; i++) {
> +		if (strcmp(key_list[i], sort_key) == 0)
> +			break;
> +	}
> +
> +	if (!key_list[i]) {
> +		for (i = 0; val_list[i]; i++) {
> +		if (strcmp(val_list[i], sort_key) == 0)
> +			break;
> +		if (!val_list[i])
> +			return NULL;
> +		}
> +	}
> +
> +
> + out:
> +	return tracefs_list_add(list, sort_key);
> +}
> +
> +/**
> + * tracefs_hist_add_sort_key - add a key for sorting the histogram
> + * @hist: The histogram to add the sort key to
> + * @sort_key: The key to sort (and the strings after it)
> + *  Last one must be NULL.
> + *
> + * Add a list of sort keys in the order of priority that the
> + * keys would be sorted on output. Keys must be added first.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> +			      const char *sort_key, ...)
> +{
> +	char **list = NULL;
> +	char **tmp;
> +	va_list ap;
> +
> +	if (!hist || !sort_key)
> +		return -1;
> +
> +	tmp = add_sort_key(hist, sort_key, list);
> +	if (!tmp)
> +		goto fail;
> +	list = tmp;
> +
> +	va_start(ap, sort_key);
> +	for (;;) {
> +		sort_key = va_arg(ap, const char *);
> +		if (!sort_key)
> +			break;
> +		tmp = add_sort_key(hist, sort_key, list);
> +		if (!tmp)
> +			goto fail;
> +		list = tmp;
> +	}
> +	va_end(ap);
> +
> +	tracefs_list_free(hist->sort);
> +	hist->sort = list;
> +
> +	return 0;
> + fail:
> +	tracefs_list_free(list);
> +	return -1;
> +}
> +
> +static int end_match(const char *sort_key, const char *ending)
> +{
> +	int key_len = strlen(sort_key);
> +	int end_len = strlen(ending);
> +
> +	if (key_len <= end_len)
> +		return 0;
> +
> +	sort_key += key_len - end_len;
> +
> +	return strcmp(sort_key, ending) == 0 ? key_len - end_len : 0;
> +}
> +
> +/**
> + * tracefs_hist_sort_key_direction - set direction of a sort key
> + * @hist: The histogram to modify.
> + * @sort_str: The sort key to set the direction for
> + * @dir: The direction to set the sort key to.
> + *
> + * Returns 0 on success, and -1 on error;
> + */
> +int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
> +				    const char *sort_str,
> +				    enum tracefs_hist_sort_direction dir)
> +{
> +	char **sort = hist->sort;
> +	char *sort_key;
> +	char *direct;
> +	int match;
> +	int i;
> +
> +	if (!sort)
> +		return -1;
> +
> +	for (i = 0; sort[i]; i++) {
> +		if (strcmp(sort[i], sort_str) == 0)
> +			break;
> +	}
> +	if (!sort[i])
> +		return -1;
> +
> +	sort_key = sort[i];
> +
> +	switch (dir) {
> +	case TRACEFS_HIST_SORT_ASCENDING:
> +		direct = ASCENDING;
> +		break;
> +	case TRACEFS_HIST_SORT_DESCENDING:
> +		direct = DESCENDING;
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	match = end_match(sort_key, ASCENDING);
> +	if (match) {
> +		/* Already match? */
> +		if (dir == TRACEFS_HIST_SORT_ASCENDING)
> +			return 0;
> +	} else {
> +		match = end_match(sort_key, DESCENDING);
> +		/* Already match? */
> +		if (match && dir == TRACEFS_HIST_SORT_DESCENDING)
> +			return 0;
> +	}
> +
> +	if (match)
> +		/* Clear the original text */
> +		sort_key[match] = '\0';
> +
> +	sort_key = realloc(sort_key, strlen(sort_key) + strlen(direct) + 1);
> +	if (!sort_key) {
> +		/* Failed to alloc, may need to put back the match */
> +		sort_key = sort[i];
> +		if (match)
> +			sort_key[match] = '.';
> +		return -1;
> +	}
> +
> +	strcat(sort_key, direct);
> +	sort[i] = sort_key;
> +	return 0;
> +}
> 
