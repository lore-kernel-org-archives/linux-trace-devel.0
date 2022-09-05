Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C6AECAAD5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Sep 2022 03:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiIEDXS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 4 Sep 2022 23:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiIEDXR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 4 Sep 2022 23:23:17 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F571903E
        for <linux-trace-devel@vger.kernel.org>; Sun,  4 Sep 2022 20:23:16 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 78so6969951pgb.13
        for <linux-trace-devel@vger.kernel.org>; Sun, 04 Sep 2022 20:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=mI3WThTxa8anja3ZVGzo1DbTVkS6Loh4pKnwr58zyPk=;
        b=ME2kmZA2Yjzw/eILiDPS4SHtVNdF0MPN+EMtTYzdNZlQL9zkl++yihKXqqXFPho5i3
         gN7iGZUFP5/g9HIdDHPYxhqJusAoUpeGdC6rXx6rOf2hsA0/aAmCDMt93UM8wFCcoUTV
         q4rmjoUhx7VghL2WMOEVlCgZIROD6XPYe3l0Zv1caCPJ6WhjKx+uftK90nl4xcMyM1vA
         CLzBZGD7ZmJGiXP+h1zc1tQh09dpQ+B9iEeWbjoCUWPQ6njdMCTNkLVEHJAgIDidg5sJ
         K3kBQ37df9YLWVye2SpkMObp6LJ1qb+5/jXrnsB7Zcf0W1s91cYe1M4lFheDVOL/A6KT
         0nBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=mI3WThTxa8anja3ZVGzo1DbTVkS6Loh4pKnwr58zyPk=;
        b=LGFdFBpa4t4X2D6YIX0Nsf5CyD1969uc1eDg84Cf43n3X/Rcx7Yg+F+lfMrv0KGwbC
         8Knl5oYmb3+CM2TR380CMMgo0+bQQ9fU9mikQMuMZ84u+vDQgCRDwnXZd+Gq5XJ5P2x5
         QQpEOe3GLPWRfebCfoFMWRUpdBXE3Yrza2TpmSClt1wk3/WZURmGgoJVPHteZ0ngAgHI
         oF8PX0nmhCnBE5qmLsP9t6c3dPsj//PmiFasO5K0ZbxX2ZopB+CNkO56NhimWyaViZIG
         r/IfGelqz9yM1/ARqLIqpgEFo4MMvdP6Xwmc0mGp7Oq0DfHpBHnqyYsUyWBuoHjtZVQD
         MGAg==
X-Gm-Message-State: ACgBeo0yeAPEDwplzgGHfzQSp+VM9mu0m8SEaqxWdTeITCUkGFmWnJJr
        +kjfcPw6MhSJ3z0JOWv+e4s=
X-Google-Smtp-Source: AA6agR4k+EhjbWXUVdUvFFWbw1xrUaFc7ppKjn3f7z7JvATx0NvX+FyzxWMOnkNmjfSR8xU1sRq3tA==
X-Received: by 2002:a63:1b59:0:b0:434:883:b055 with SMTP id b25-20020a631b59000000b004340883b055mr8735252pgm.50.1662348195735;
        Sun, 04 Sep 2022 20:23:15 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id r1-20020aa79ec1000000b00536fc93b8c8sm6422826pfq.20.2022.09.04.20.23.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 04 Sep 2022 20:23:15 -0700 (PDT)
Date:   Mon, 5 Sep 2022 11:23:14 +0800
From:   lijiazi <jqqlijiazi@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220905030209.GA5577@Jiazi.Li>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
 <20220901111320.04b57cb7@gandalf.local.home>
 <20220902031717.GA27303@Jiazi.Li>
 <20220902085641.32ba1651@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902085641.32ba1651@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Sep 02, 2022 at 08:56:41AM -0400, Steven Rostedt wrote:
> On Fri, 2 Sep 2022 11:47:58 +0800
> lijiazi <jqqlijiazi@gmail.com> wrote:
> 
> > Yes, I'm thinking this may be a race issue too.
> > But I didn't find race point through code review.
> 
> I think I may have found it. Can you test this patch?
> 
Sure, I will test this patch.
Thanks!
> [ Disclaimer, I did not even try to compile it ]
> 
> -- Steve
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index d59b6a328b7f..0f47e68fee9b 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -4580,6 +4580,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	goto again;
>  
>   out:
> +	/* If the commit is past the end of page, a writer is still updating it */
> +	if (reader && rb_page_size(reader) > BUF_PAGE_SIZE)
> +		reader = NULL;
> +
From ramdump, current reader page's commit is 0xff0, not bigger than
BUF_PAGE_SIZE:
crash> struct buffer_page 0xffffffd10b599580 -x
struct buffer_page {
  list = {
    next = 0xffffffd10b599500,
    prev = 0xffffffd10b599680
  },
  write = {
    a = {
      counter = 0x100ff0
    }
  },
  read = 0xfd4,
  entries = {
    a = {
      counter = 0x100053
    }
  },
  real_end = 0xfd4,
  page = 0xffffffd10b553000
}
crash> struct buffer_data_page 0xffffffd10b553000 -x
struct buffer_data_page {
  time_stamp = 0xe2679ca0cd3d,
  commit = {
    a = {
      counter = 0xff0
    }
  },
  data = 0xffffffd10b553010 "\b"
}
I also can extrace trace log from ramdump by crash-trace extension tool:
bsp: <...>-32191 [006] 249032.606401: signal_generate:      sig=17 errno=0 code=1 comm=WifiDiagnostics pid=1535 grp=1 res=1
bsp: <...>-32183 [006] 249032.625192: sched_process_exit:   comm=osi_bin pid=32183 prio=120
bsp: <...>-32196 [006] 249033.677333: sched_process_exit:   comm=ip pid=32196 prio=120
bsp: <...>-32196 [006] 249033.677562: signal_generate:      sig=17 errno=0 code=1 comm=sh pid=32195 grp=1 res=0
Above logs is on reader page, reader task try to read PADDING event
after this event and lead to crash.
below logs on tail page:
bsp: <...>-32195 [006] 249033.677596: signal_deliver:       sig=17 errno=0 code=1 sa_handler=6385258d68 sa_flags=0
bsp: <...>-32195 [006] 249033.678561: signal_deliver:       sig=17 errno=0 code=1 sa_handler=6385258d68 sa_flags=0
bsp: <...>-32195 [006] 249033.680041: sched_process_exit:   comm=sh pid=32195 prio=120
bsp: <...>-32195 [006] 249033.680096: signal_generate:      sig=17 errno=0 code=1 comm=osi_bin pid=4505 grp=1 res=2
>  	/* Update the read_stamp on the first event */
>  	if (reader && reader->read == 0)
>  		cpu_buffer->read_stamp = reader->page->time_stamp;
