Return-Path: <SRS0=cY0P=WB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F99FC0650F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 12:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EFE32067D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 12:39:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hL8IL3ql"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfHEMjc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 08:39:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38119 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfHEMjc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 08:39:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so51505657wmj.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 05:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bfIkObNnX/Dk0CcxI+IxmQIHozQTI2YMt+ZV+QG+fzc=;
        b=hL8IL3qluRjoL5So+bnXt98jYqQ8fIJHjgdTrECkVbp5xp9kua58ogmsu3Dx+nGhXY
         fAbo4Wph9AFBILSygA+n+8Wa7EBZPzVleByUesUTjEzBIqVpOx2rRrVh2r9ksUmhzrml
         QyKrWfzHqYqKEoA3bH/6heCZ2A24hxz+RNvQWNLsa9L6ZrfnqCvyWRbwrsmm0lJSH0OW
         74US1d05fIior06WPorghB4p1CtZlxepVpvPzgKvaxm/00lO1iPIslfgP56AtFtCsdBR
         z14Q/pPx0TAoOyv42xlTUlfEZIIky46VuNkwC9lyK2WuxpDDbYia+FiW60kS5Y5xcBGi
         QuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bfIkObNnX/Dk0CcxI+IxmQIHozQTI2YMt+ZV+QG+fzc=;
        b=e/z7eV0jfDsTsoBNDC2s2aal+z6b6G1/LIKxcqL3TwL+M0v3qp9H/JLEJ5Lg1ZHPpI
         GMlBt6ASdFhFOTkB8wJ7EpvobpBYPJRd8X3P0qF+MzVNNVqdUiajLENr/biePvTcCmMI
         qdBvTcm3acgTbZB8iQ2eZjgbo/9WXAsMOpAxFEtgDvrDN0QF7glUzW2L6Laf1NH6vHTa
         duhrAmhjEZrLdjT8OjerQ/U/DovgoNzT6M2KDCcZW3hbXgrCIaFhpyY8Txvs2GzK7E/h
         h0jjhdif13x8PXHMQ9/HXyqP73CniBYmdfJwWbH4qI3Hol4NpELWEQc1AZAZOYZ1OgpK
         k3fA==
X-Gm-Message-State: APjAAAUrImeZlMh5XPT+Dwl4nWwQafjhtFaEpuAXdOq8+IQzwBriljti
        rp75nV6AlAIkmP4L2PecHM0DuB6w5bA=
X-Google-Smtp-Source: APXvYqwHtwThL9mDyqBGCQzrPBYTnjjXAx+3xGOkI8iKEyzD5LXApqEc3Woj+OseMkOA8B+3hThy6g==
X-Received: by 2002:a1c:9d53:: with SMTP id g80mr18805475wme.103.1565008770049;
        Mon, 05 Aug 2019 05:39:30 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u1sm79967047wml.14.2019.08.05.05.39.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 05:39:29 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Separate trace-cmd and kernelshark
 documentations.
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190801121955.20393-1-tz.stoyanov@gmail.com>
 <20190801092554.3b32dc91@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <4f359c7f-de0c-44df-b975-44d8438176e6@gmail.com>
Date:   Mon, 5 Aug 2019 15:39:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801092554.3b32dc91@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 1.08.19 г. 16:25 ч., Steven Rostedt wrote:
> On Thu,  1 Aug 2019 15:19:55 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
>> KernelShark is going to be a stand alone package, separate from trace-cmd.
>> The code is already in its own directory, but HTML and man page documents
>> are still not separated.
>> All KernelShark related documentation (HTML and the man page) is moved
>> from Documentation/ to kernel-shark/doc/ directory.
>> New targets are added to trace-cmd Makefile:
>>   doc_gui - build KernelShrak documentation
>>   doc_gui_clean - clean KernelShrak documentation
>>   install_doc_gui - install KernelShrak documentation
>> The existing Makefile targets:
>>   doc, doc_clean, install_doc
>> are modified to work only with trace-cmd documentation.
>> The new Makefile targets must be used to build and install KernelShark docs.
>>
>> This change was requested by Bas van Dijk <v.dijk.bas@gmail.com>, to
>> simplify packaging trace-cmd and kernelshark for nixpkgs, as two
>> different packages.
>>
>> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>> ---
> 
> 
>>   rename {Documentation => kernel-shark/doc}/HTML/images/kernelshark-logo.svg (100%)
> 
> When I first saw this, I questioned moving this out of Documentation.
> But thinking about it more, it does make sense.
> 
> But can I ask you to keep the "Documentation" name?
> 
> It just seems more professional, and also stays in line with the
> trace-cmd and Linux kernel "Documentation" directory name.


I agree. Let's rename kernel-shark/doc to kernel-shark/Documentation.

Thanks!
Yordan

> 
> Thanks!
> 
> -- Steve
> 
