Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0768C07E9D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Sep 2022 09:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiI2JOA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Sep 2022 05:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiI2JNg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Sep 2022 05:13:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AD21438C5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Sep 2022 02:13:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so748804pjr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Sep 2022 02:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=O/WYkfIInpW+mzKt5Vdu7lLSfaTJIvvi0u1lG1bNUsA=;
        b=H/YhIKsZnVY4HYwR/1NOCZh6I6xhbAeRSyyA3yWrb4cN4g/233t3/bqqwl7X5tAd8M
         /fKkhAPL65vCP3hdDs/ifYGcxI59QFfzmiO5I2WkSKxBdiLRPmRTfsDVnhKAm28xN6J2
         a6y0sPfCyDwPZ9brY/cq9DApkO3nyxBT6tONeOYE2+hCLULgxUJWtXNXYt1N5pvdOsSL
         1liv4cFBOlS3h5gW7MjVytqb8Ye65mBWU1cepOKRudWVDyECXPJNsy7C8HPiwb8DehEJ
         vDlliS3QatKym5WMjjX2djet0sAHaY3xeW3xQOx/Bk8YIMziG4MDIASLmsimevl4GNhM
         NWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=O/WYkfIInpW+mzKt5Vdu7lLSfaTJIvvi0u1lG1bNUsA=;
        b=4rgFrRj+Y0zjOJTSagbz+PCtwKhz0hQ5uskNkIwvZaY0uB70GsPPlRkEm5DNcD2uES
         7IZjaPfKyYRZjM1LSZnSXFwjw2zZaoHVGsCukDhE2WpJY2Cpp0YtqK5CfOMG4sqnQPAG
         NSp2h94wdEPZsi1aOGiE0aN12PemOS5hXl+JVdPHYNH9MyNdUhZG8W5Xmr//XZjMB9NC
         KFhfgk6uEe9lGQoH5eIe0E6qYY+QPldE3h8s3ArpRFPGlCjyA830GloBwv5hi0tkGKtl
         yAisp2Eb9e8j/E5fdUI3hU65yrk6iMkHsJeKRpzq6bkaqDsV4d0mNRFq9qWmXKzx8fGW
         +uIA==
X-Gm-Message-State: ACrzQf32mD06RU56mDWT/ODSwPnAfDX9U5iztvhCQJawigA/mDtKsI/6
        rZR18QgIVp/DZoKck9Vk0rI6nJR6Hm4=
X-Google-Smtp-Source: AMsMyM70+IkvetpCxjVUu67QT57puuZmff8VA3jOqjtPZ66eZ8mCA8pJc4H9CIh8W42TETc57UZFPw==
X-Received: by 2002:a17:90a:d908:b0:206:122:35d1 with SMTP id c8-20020a17090ad90800b00206012235d1mr2521704pjv.245.1664442788308;
        Thu, 29 Sep 2022 02:13:08 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902e54900b00174abcb02d6sm5330801plf.235.2022.09.29.02.13.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Sep 2022 02:13:07 -0700 (PDT)
Date:   Thu, 29 Sep 2022 17:12:01 +0800
From:   lijiazi <jqqlijiazi@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220929091201.GA21685@Jiazi.Li>
References: <20220901111320.04b57cb7@gandalf.local.home>
 <20220902031717.GA27303@Jiazi.Li>
 <20220902085641.32ba1651@gandalf.local.home>
 <20220905030209.GA5577@Jiazi.Li>
 <20220906122542.1bab4663@gandalf.local.home>
 <20220907081358.GB24124@Jiazi.Li>
 <20220915081414.GA12602@Jiazi.Li>
 <20220928105443.1e7e4555@gandalf.local.home>
 <20220928105935.578b72b6@gandalf.local.home>
 <20220928162908.07b12250@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928162908.07b12250@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Sep 28, 2022 at 04:29:08PM -0400, Steven Rostedt wrote:
> On Wed, 28 Sep 2022 10:59:35 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Will reply with an updated patch.  
> > 
> > Can you try this patch?
> 
> Actually, that failed my testing (for other reasons), can you try this one?
> 
Sure, thank you.
> -- Steve
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 3046deacf7b3..46b6f4107428 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2648,6 +2648,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  		/* Mark the rest of the page with padding */
>  		rb_event_set_padding(event);
>  
> +		/* Make sure the padding is visible before the write update */
> +		smp_wmb();
> +
>  		/* Set the write back to the previous setting */
>  		local_sub(length, &tail_page->write);
>  		return;
> @@ -2659,6 +2662,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  	/* time delta must be non zero */
>  	event->time_delta = 1;
>  
> +	/* Make sure the padding is visible before the tail_page->write update */
> +	smp_wmb();
> +
>  	/* Set write to end of buffer */
>  	length = (tail + length) - BUF_PAGE_SIZE;
>  	local_sub(length, &tail_page->write);
> @@ -4627,6 +4633,29 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	arch_spin_unlock(&cpu_buffer->lock);
>  	local_irq_restore(flags);
>  
> +	/* The writer has preempt disable, wait for it. But not forever */
> +        for (nr_loops = 0; nr_loops < 1000; nr_loops++) {
> +		/* If the write is past the end of page, a writer is still updating it */
> +		if (likely(!reader || rb_page_write(reader) <= BUF_PAGE_SIZE))
> +			break;
> +
> +		udelay(1);
> +
> +		/* Get the latest version of the reader write value */
> +		smp_rmb();
> +	}
> +
> +	/* The writer is not moving forward? Something is wrong */
> +	if (RB_WARN_ON(cpu_buffer, nr_loops == 1000))
> +		reader = NULL;
> +
> +	/*
> +	 * Make sure we see any padding after the write update
> +	 * (see rb_reset_tail())
> +	 */
> +	smp_rmb();
> +
> +
>  	return reader;
>  }
>  
