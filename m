Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CC8DDC7
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 15:19:22 +0000 (UTC)
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CB2A7
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 08:19:19 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7a2bfd584f0so1583839f.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Oct 2023 08:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696346358; x=1696951158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zxzfJaXGdl6XhPaM/xafYq1hwD7Fn91I2+trynKl1jY=;
        b=Kl9Ig3NwVoCuBu3mZjW+OqFNipyjAm5TkOJiZMOBZUhIfxzjDjFLYCPMHqBtbKRCIL
         Fex0aYihw6iBIyXzHu/YYbEBVn4MrK/qm2bESn+o4vWTGjrOt7jEmKbRyLqbSmVKZaI3
         RvbdpfNVFIObc6m3BuA9Pd3U+xH/3Fm5wT2rltxJ3Ev8R4u1Y7LwF5rgjqnzOXgETLIC
         a/kyDyicaMtBCMHLFmaK9hdBZfEwcp94mn9yH2eFEOZdsYLqoLCL6zP74IxMX5+zqkow
         YoLWRQzMjTJBkbh4criX6doL13Av8QndZbLUe5r1Hc8mkPaLN4wRqzEMqHa8DztwfZik
         ZhLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696346358; x=1696951158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zxzfJaXGdl6XhPaM/xafYq1hwD7Fn91I2+trynKl1jY=;
        b=b2rog8ssJJr6Pu7AEm4bvta5adhBU4nXvTUaGuWQJt5ePEv4EZ9NUUoGEbeMqf4FS7
         AFF1FY2iTjavb4u5dMWvFWOmKiqu3MEbk7zG1HKSLxqJXxUzdgkpYqrESatANj0bQ3Bn
         Lsm0irJhvVlKD0CTQ1OTGXYRgQe86koYtGJU5IBs+UykePFlb48ZFrMXI2KbxLswS/42
         ToHHbRAiRKjEz+IXIRIR3cIg2Nu8IJbVA64QZF356BT1n0jlUa2M59St1jX1LX3eE3nA
         ZKXDq9FTCmeyEgruHVSFBjs/JD8pkl1zknP5Toq82HDUU1oo5MF8gk4UcrYaZsgypEHa
         3B5Q==
X-Gm-Message-State: AOJu0YwOuPc8gJfG9aiAHB7ybx7epa/3XiaCk0mGvOEaMjsJE72bnZ//
	NM/zRad42zybzfnqfrfucXMH/8u4LVlOOE01srnXew==
X-Google-Smtp-Source: AGHT+IHbF5FgeRIyEQ8bYOoELXUEgNaY0RuTGGXTuT0P5iyN9yf6EIJGTPm+dhXLlDJ9267PXSf9kA==
X-Received: by 2002:a05:6602:86:b0:787:1d0a:ce81 with SMTP id h6-20020a056602008600b007871d0ace81mr16413158iob.13.1696346358494;
        Tue, 03 Oct 2023 08:19:18 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:d5ff:6f50:bbbd:a922])
        by smtp.gmail.com with ESMTPSA id em12-20020a0566384dac00b0043e8735ea88sm389355jab.139.2023.10.03.08.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 08:19:17 -0700 (PDT)
Date: Tue, 3 Oct 2023 09:19:14 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2] libtraceeval: Fix comparing unsigned against zero
Message-ID: <20231003151914.GA1935474@google.com>
References: <20231003091032.06e697a3@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003091032.06e697a3@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Oct 03, 2023 at 09:10:32AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> nr_key_types and nr_val_types are both size_t which is an unsized number.
> A compare against zero is always false:
> 
> 	if (teval->nr_key_types < 0)
> 
> Change them to ssize_t (signed type).
> 
> Also change the few places the "size_t i" is used where it does:
> 
> 	for (; i >= 0; i--)
> 
> as that too needs to be signed to work.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
