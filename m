Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93899C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 11:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C21820848
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 11:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcpSoQh6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfDOLGC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:06:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51688 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfDOLGB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 07:06:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id 4so20097193wmf.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 04:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=03D+9Zb4zqJhIhlnU0RgpplIBTN6zWczgNh5ykClW/I=;
        b=AcpSoQh6c30gAuaIyyCzjTRUJOueRZuTD71NVSmCfe1/9YHGDMn3qkiu7ByZnsVaPa
         dGo1R7jOQr26D9WPZEfJkXTVUefnKKn353pkWnQ+Kk/hjKxsBM3pdPmDfUb7useXc8mM
         qqmVhD3u60NJzm52eS9eCfqjh9moXwtml4hDQbqSLzi22j8nRh+/2vKd7uUrpwIQrV9x
         ItzLZpI7ImJm26CaLfuSt4lo9McqogxLKJoVw/mrG1ol2PUVzwXFq6dZ3eXT6F6NUY82
         6DFSAJe1ANeaXnbryeES6/xOWWptagJZA+gpXyAVggixknD8acPjLUUyg93+ZcMNH/pe
         rq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=03D+9Zb4zqJhIhlnU0RgpplIBTN6zWczgNh5ykClW/I=;
        b=eL0IbAnWLJ4poMm8ao2Ifhal1t4QJhNYepQqmMp0y81V/9tjIT9hRs2cu+/si7x0un
         ILLQ7I5vYoB1GM9euA8dyscUuIoA7xvuvCr/Vu8emezNP+ymFj4+FJ/2phBBJdOP7/dL
         m74NS/L46x25JiE6dK+U8TxTehfg/jR1AluxsxTD2hKGkr3jDRQYc+nA+M1aozvhXkc8
         KVYkujXvHX54aEBri2nOId7nKj/ESc56qegeNxrFbQtw8kQHZi3b6fKoQQFCMriy3JZY
         8LKGkxA7iaJzR/lthZczfeDUHEfFGTnagpAqt4WdTnVJna4VS61VfrB9PGKY/CT0FESf
         Awdg==
X-Gm-Message-State: APjAAAWqfbzlGxZ67UtwX9YdKrOzSapohy7TeeZ686eB56qQ4vA8oHMx
        IhMl92eswANulyVFXvcIVmYfb8IO
X-Google-Smtp-Source: APXvYqw6VAXqoVEKQ63Q+RHgkgaXXZgHoe6ujdWrpEnDxyrVy+GENDPR8K0tccIBmqhp2rTUcqKNlg==
X-Received: by 2002:a1c:a103:: with SMTP id k3mr21814462wme.8.1555326359765;
        Mon, 15 Apr 2019 04:05:59 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y132sm19368299wmg.38.2019.04.15.04.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 04:05:59 -0700 (PDT)
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
To:     Slavomir Kaslev <kaslevs@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
 <20190404145603.13592-2-ykaradzhov@vmware.com> <20190408150102.GA6430@box>
 <20190408111308.301f30c1@gandalf.local.home>
 <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
 <20190409092349.3e7cb6e3@gandalf.local.home>
 <CAE0o1NtOBbVGjHfYyqOhrCrmywSNjYWOprDU66uMTPx4hX4UGA@mail.gmail.com>
 <20190409111100.28297adb@gandalf.local.home>
 <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <edebede3-e508-022e-5d71-13226cd2df58@gmail.com>
Date:   Mon, 15 Apr 2019 14:05:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9.04.19 г. 18:44 ч., Slavomir Kaslev wrote:
> The problem is the way they are defined atm:
> 
> # First search in the user provided paths.
> find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
>                                  PATHS  $ENV{TRACE_CMD}/tracecmd/
>                                         ${CMAKE_SOURCE_DIR}/../tracecmd/
>                                  NO_DEFAULT_PATH)
> 
> This will never evaluate to /usr/bin which is what it should be for
> distro builds.

I think there is a bit of confusion here. The code above will never 
search in /usr/bin. This statement is correct.

However if this search fails we will perform another search that will 
this time search in /usr/bin. Look few lines below in  FindTraceCmd.cmake.

The reason for this is to avoid confusion in the case when the user has 
the distro package installed, but in the same time is trying to build 
KernelShark from source. We want in this case the GUI to link with the 
version of the trace-cmd library that is being build (not the one from 
the package).

Thanks!
Yordan


