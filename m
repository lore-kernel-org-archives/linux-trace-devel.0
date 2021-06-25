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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C18C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 13:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38DD61973
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 13:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhFYOAW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFYOAV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 10:00:21 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D630DC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Jun 2021 06:58:00 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j11-20020a05600c1c0bb02901e23d4c0977so7900453wms.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Jun 2021 06:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ThKHjFGabdnqAMUAbMlitHHBYSvmUkQxeWl2FxMXUNU=;
        b=SS3bTrS2XmikOD8tcDLI95MSr/4xtGHDau/tGf8sS97aGCCUo8o4A/bH5Vgw5knU6P
         NNRv8nNDJU0m2Mqv3uKWk1RXKJLU4LffC4NTeE6fMF7cIdAexlpdCafNZNj/0qbxxhRE
         dJne2oa8macXw2G/l3U3wE+rZcN4eJ4MsEceLFr+p1COf+v43NvebrY6yN67IIVwQ0B0
         xzeFnD4dwwYw4qEJihYPw6DCB2rJSpfl83yVj0oRiQUMwO3t4V2HiEgFFMsiAyL5R7OJ
         e2QJqcJy+wxEIbtWbO0lyb+wuUEX84DiFx4MMNArBxg0WMZ50iFkuhCa2yDmMnve7UBw
         lbrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ThKHjFGabdnqAMUAbMlitHHBYSvmUkQxeWl2FxMXUNU=;
        b=H6GbKDTSDtJQeuiv5NJ5SpQV8iSs4aEMIGFUqcjNz4DX2+Y9xf13WyqaIhVA0oehDw
         lPeNgAwGXBOp27Nk4k8tBQ0PgnwfIrGZNlYApo1TQBu/cQoo8s+TWVtRup91pX0+LzEW
         AqQihOWSwnnFqX80ZQFheR1NsGODyC3OFCt9+cCmhWE/TqsZ7XEqo6Mf6r40AEgeKa37
         OLbiyJ1U7u5jHVXH3F7VfFfY/4SUASr2eMlpAvB0LKfYR+G1e381VfZMc78eruwsPaj3
         GQFqOLTMIx5sZ8esp/FvtQMP60DY0aYAoToG/cKO3Utw8WjoWkCj+FSMjC8CNDaS3L3m
         VVkw==
X-Gm-Message-State: AOAM53352/hEM4mCJeRHlLm4HmHgjwhnOIekxWamTHAX0pHgxBB0Tuf9
        o+AaSact+opbowAUNLyJ/opcGjSeDO0=
X-Google-Smtp-Source: ABdhPJzPzRedstw0YWv1jDD/oflqOsayLb1SCNW8+gNNSHJb0DUHYXnM9Bue88+tT3CWKaGPGlYm0g==
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr10914962wmb.142.1624629479265;
        Fri, 25 Jun 2021 06:57:59 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id 9sm12390532wmf.3.2021.06.25.06.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 06:57:58 -0700 (PDT)
Subject: Re: [PATCH v3] libtracefs: Add APIs for data streaming
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210624145101.87233-1-y.karadz@gmail.com>
 <20210624124542.5ca75fe3@oasis.local.home>
 <835ff5f9-5fed-0dfb-2d75-dd9158fb63a7@gmail.com>
 <20210625094624.6da9a90f@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <e2ab5710-95f9-f510-5249-3291c68b9ae5@gmail.com>
Date:   Fri, 25 Jun 2021 16:57:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625094624.6da9a90f@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 25.06.21 г. 16:46, Steven Rostedt wrote:
> On Fri, 25 Jun 2021 16:17:14 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> On 24.06.21 г. 19:45, Steven Rostedt wrote:
>>> On Thu, 24 Jun 2021 17:51:01 +0300
>>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>>    
>>>> The new APIs can be used to dump the content of "trace_pipe" into a
>>>> file or directly to "stdout". The "splice" system call is used to
>>>> moves the data without copying. The new functionality is essentially
>>>> identical to what 'trace-cmd show -p' does.
>>>>
>>>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>>>>   
>>>
>>> So I did some investigations here, and found that splice() is not
>>> guaranteed to work on a terminal output.
>>>
>>> To overcome this, I decided to have the print create another pipe, and
>>> pass that to the stream code. The if something was read, it would read
>>> the pipe.
>>>
>>> It required changing the return of the functions to return the amount
>>> transferred, so that I can differentiate between "EOF" with nothing
>>> read, and something read. Because I couldn't get the pipe to not block
>>> on read if there was no content in it. :-/
>>>
>>> Anyway, I submitted a v4 with the changes I made, and it appears to
>>> work. I haven't tested it that much, so it may still have bugs.
>>>    
>>
>> Hi Steve,
>>
>> I tested v4 of the patch that you submitted and it doesn't work correct in my use case. Also it seems greatly
>> over-complicated to me. Note that when you call tracefs_trace_pipe_stream() inside a loop you will keep opening and
>> closing the "trace_pipe" and the pipe over and over again.
> 
> Good point. I could update it to pull out the main work of the splice
> logic and have both functions use that, and not have one call the other.
> 
> What didn't work with your use case?
> 
>>
>> See the example code below. Is this what you are aiming? Also is this guaranteed to always work?
> 
> Similar but I'll comment below. Note, the real issue I had in testing
> my code was blocking. The read on the pipe would block on EOF even with
> a NONBLOCK flag :-/ Which is not what I wanted, and to fix that, it
> made the code a bit more complex.
> 
>>
>> Thanks!
>> Yordan
>>
>>
>> #define _GNU_SOURCE
>> #include <fcntl.h>
>> #include <unistd.h>
>> #include <signal.h>
>> #include <stdbool.h>
>> #include <stdio.h>
>> #include <errno.h>
>>
>> volatile bool keep_going = true;
>>
>> static void finish(int sig)
>> {
>> 	keep_going = false;
>> }
>>
>> int main(int argc, char **argv)
>> {
>> 	int splice_flags = SPLICE_F_MORE | SPLICE_F_MOVE;
>> 	int brass1[2], brass2[2], fd, ret;
>> 	char buf[BUFSIZ];
>>
>> 	signal(SIGINT, finish);
>>
>> 	fd = open(argv[1], O_RDONLY);
>> 	if (fd < 0) {
>> 		perror("open");
>> 		return 1;
>> 	}
>>
>> 	if (pipe(brass1) < 0){
>> 		perror("pipe A");
>> 		return 1;
>> 	}
>>
>> 	if (pipe(brass2) < 0){
>> 		perror("pipe B");
>> 		return 1;
>> 	}
>>
>> 	errno = 0;
>> 	while (keep_going) {
>> 		ret = splice(fd, NULL,
>> 			     brass1[1], NULL,
>> 			     BUFSIZ, splice_flags);
> 
> The above can block, and if it does, and you hit "ctrl-C" it will
> return with ret < 0 and have errno set to EINTR.
> 
>> 		if (ret < 0) {
> 
> With a Ctrl-C, this would error.

Yes, Isn't this what we want. We want to stop the loop.

Thanks!
Y.

> 
>> 			perror("splice A");
>> 			return 1;
>> 		}
>> 		ret = splice(brass1[0], NULL,
>> 			     brass2[1], NULL,
>> 			     BUFSIZ, splice_flags);
>> 		if (ret < 0) {
>> 			perror("splice B");
>> 			return 1;
>> 		}
>>
>> 		ret = read(brass2[0], buf, BUFSIZ);
> 
> Same here, with the blocking issue.
> 
> -- Steve
> 
>> 		if (ret < 0) {
>> 			perror("read");
>> 			return 1;
>> 		}
>>
>> 		ret = write(STDOUT_FILENO, buf, ret);
>> 		if (ret < 0) {
>> 			perror("write");
>> 			return 1;
>> 		}
>> 	}
>>
>> 	close(fd);
>> 	close(brass1[0]);
>> 	close(brass1[1]);
>> 	close(brass2[0]);
>> 	close(brass2[1]);
>>
>> 	return 0;
>> }
