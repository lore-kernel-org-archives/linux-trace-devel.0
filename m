Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491B9C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 13:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2290461963
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 13:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhFYNTj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 09:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhFYNTi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 09:19:38 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9086C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Jun 2021 06:17:17 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o35-20020a05600c5123b02901e6a7a3266cso3436344wms.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Jun 2021 06:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jMnrxOarW2WsI7LAJ6IVtiCjQzECm0F5WAlu5kIUqiU=;
        b=rJG58dPIzcSEpKxo/rE6kJvXz9NG9Yj4sWLSW9rtBtWXCbX6q3gH5KU/A4bgRSIN6V
         vh4g0/EblNqD8RWT1K0JCuu570RrMwRzh8C42miUkT1hU8UGmxW5+4T1Zek2WRnXsjGm
         GOG8emNqydgXpOjk3oq8vLL67CLWXfKIY/J7dJqQPEoDxs1wdxoxw/6Fr5s5JUldEFAT
         pXBH/nxqUL7ggLXnPDciycsbcnnVbufW6dO63g3qFFVHoAR3B3BpuRLBkpjH6dTaaIEJ
         o3k4N2l2SasERLkfLzLzDbNtxINK5mgZgpYJYQ1epb/KC0AhIlWyTfb6CezYEGudvS09
         +yuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jMnrxOarW2WsI7LAJ6IVtiCjQzECm0F5WAlu5kIUqiU=;
        b=thMzK8k1QVj6KI9N7ElWGjmqbamfN5lTYS0V2ZlXrgryYL0xAFbFzgiThkEz2nhSb9
         NuJ1a7/NACa2kU3xbZlXg2iTRowkRNFR5zlT+kN/31+3IhEy6hazUdrIK1u7v3cJVncn
         AmA9sDdwdYFHoiXYmLlbpBYrnk1DvBgjoPJoZdZHWFjmQ/eiK2gj7/yS3J1TSFC4sz7K
         Zn8zSJoMb3XrhCupObo+dzeXimm3Jf59TuF33cxQSSPHlG53nBCQ4baEdhtW5QK4ChKw
         xBSByjpw+ohZRgFmEfknfe/XJy/z4ogZDMrmfQ5cT7dhZxEJhaTTQCZINLORgNvD0dgZ
         5qvQ==
X-Gm-Message-State: AOAM533jeMJRiVKLa/p6hCMMwDK2a6j170eMMwECcP/sbSAhCzlwnYL7
        UAxR6zXUsvuvEhEPToWo6h46LT/K8l4=
X-Google-Smtp-Source: ABdhPJyv8Gg1Jm87fd1MuvOEC2HvwJM/nhk55SgRUFvmXlF88QkNRcMISGHtjgDEqSBiKw0jorvPPg==
X-Received: by 2002:a05:600c:3b28:: with SMTP id m40mr10528138wms.99.1624627036163;
        Fri, 25 Jun 2021 06:17:16 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id c8sm5914819wri.91.2021.06.25.06.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 06:17:15 -0700 (PDT)
Subject: Re: [PATCH v3] libtracefs: Add APIs for data streaming
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210624145101.87233-1-y.karadz@gmail.com>
 <20210624124542.5ca75fe3@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <835ff5f9-5fed-0dfb-2d75-dd9158fb63a7@gmail.com>
Date:   Fri, 25 Jun 2021 16:17:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624124542.5ca75fe3@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 24.06.21 г. 19:45, Steven Rostedt wrote:
> On Thu, 24 Jun 2021 17:51:01 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The new APIs can be used to dump the content of "trace_pipe" into a
>> file or directly to "stdout". The "splice" system call is used to
>> moves the data without copying. The new functionality is essentially
>> identical to what 'trace-cmd show -p' does.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>>
> 
> So I did some investigations here, and found that splice() is not
> guaranteed to work on a terminal output.
> 
> To overcome this, I decided to have the print create another pipe, and
> pass that to the stream code. The if something was read, it would read
> the pipe.
> 
> It required changing the return of the functions to return the amount
> transferred, so that I can differentiate between "EOF" with nothing
> read, and something read. Because I couldn't get the pipe to not block
> on read if there was no content in it. :-/
> 
> Anyway, I submitted a v4 with the changes I made, and it appears to
> work. I haven't tested it that much, so it may still have bugs.
> 

Hi Steve,

I tested v4 of the patch that you submitted and it doesn't work correct in my use case. Also it seems greatly 
over-complicated to me. Note that when you call tracefs_trace_pipe_stream() inside a loop you will keep opening and 
closing the "trace_pipe" and the pipe over and over again.

See the example code below. Is this what you are aiming? Also is this guaranteed to always work?

Thanks!
Yordan


#define _GNU_SOURCE
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <errno.h>

volatile bool keep_going = true;

static void finish(int sig)
{
	keep_going = false;
}

int main(int argc, char **argv)
{
	int splice_flags = SPLICE_F_MORE | SPLICE_F_MOVE;
	int brass1[2], brass2[2], fd, ret;
	char buf[BUFSIZ];

	signal(SIGINT, finish);

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (pipe(brass1) < 0){
		perror("pipe A");
		return 1;
	}

	if (pipe(brass2) < 0){
		perror("pipe B");
		return 1;
	}

	errno = 0;
	while (keep_going) {
		ret = splice(fd, NULL,
			     brass1[1], NULL,
			     BUFSIZ, splice_flags);
		if (ret < 0) {
			perror("splice A");
			return 1;
		}
		ret = splice(brass1[0], NULL,
			     brass2[1], NULL,
			     BUFSIZ, splice_flags);
		if (ret < 0) {
			perror("splice B");
			return 1;
		}

		ret = read(brass2[0], buf, BUFSIZ);
		if (ret < 0) {
			perror("read");
			return 1;
		}

		ret = write(STDOUT_FILENO, buf, ret);
		if (ret < 0) {
			perror("write");
			return 1;
		}
	}

	close(fd);
	close(brass1[0]);
	close(brass1[1]);
	close(brass2[0]);
	close(brass2[1]);

	return 0;
}



> We could optimize it to just use the splice output first (stream
> first), and if that returns with EINVAL, which is the expected error on
> a non functioning stdout, we could then switch to this alternate method.
> 
> Although, the stream would have read some of the pipe and lost the
> data, which is not what we want, so a test of stdout would need to be
> made with splice first. :-/
> 
> -- Steve
> 
