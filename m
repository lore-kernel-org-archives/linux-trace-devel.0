Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F294415BD
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 18:33:25 +0000 (UTC)
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C86FAC
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 11:33:24 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-351574aca7bso132225ab.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 11:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696271603; x=1696876403; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRXTnGAiH+Z1D8khuNVF4RPJ0CFMcMIXAmeowRVC574=;
        b=G9gO3yVtw4UVIBNDJ9F0TbNw+V5a80msg8r6dKLuwxDPRcx6pQJ4IhDfPkNNbyU5T8
         qmnIV9AGUW+h1U2odsjh2B8HDAOLPeN39THuDGtAgrZ33Q3KIdeKN+GSb5eIzewPosYL
         97flKMKy+5s4cSO7HouwZVdJIYgbDcimgmleSvRP0Ca08QPKqtyP6ggA81cz3mPPci30
         R3Pyxd5Oxr7maHXeiTgU9nVrNu1JbXMVxndwAhVCWIs/5Da/gDMkfV7AqobiGH0ceNjs
         WCGpirwqYlk1dDNYzCn4jNTt5178Fso62kx/fttVtmIQVFoX0X7U8z7aAy2EWYEch0LZ
         ulFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696271603; x=1696876403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRXTnGAiH+Z1D8khuNVF4RPJ0CFMcMIXAmeowRVC574=;
        b=QaiRx9KVhZeCr7A3WR6NOSHBNZb5u/j2Dh4qo5CxZG4W3nHJAkahpOXlfobD0JdFOc
         DWzjAMFzIs7UPS74iwoMOaUu93PrSkaz3DokGR1QMPFOCbqsV2NOgYE6++qt8Yvg3qlF
         r535aj5pDvjMVNiJf6XQ2l/Q/il+eaE2YBMis+tEpMZSkMtAxvOufLJEnNDraolBkKPl
         1fUoQy5TBXAtEHgrzJ5ocKR9AekJCkXAYfg0ogS0MHxWQ9plTMqFRJwOZP530HOLvsDN
         SWj3jBUf5TMVwTQtBQ7CWqinhqzctnVo7Coagu6NVuuXDwwpdePpdwiezHF2hByBl2hU
         3NGg==
X-Gm-Message-State: AOJu0Yx3lwxQvU2q0RsJWAsUcpQxToxqLkglbx0NgqCvZnfkEWKxKAug
	szbp5Q9lkgQw0o0uu65Tpz1jQ7I0XJeMiFEILXY95Q==
X-Google-Smtp-Source: AGHT+IHK+TTyUj+Xb38Y1Dx3egh0mLMow7oCQJpQGNCBv5+OgQhSByahksdtONY1MhqKr1zMRypMpA==
X-Received: by 2002:a05:6e02:1448:b0:351:4cdd:f50e with SMTP id p8-20020a056e02144800b003514cddf50emr14609268ilo.12.1696271603594;
        Mon, 02 Oct 2023 11:33:23 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id l13-20020a02cd8d000000b0042b05586c52sm7233853jap.25.2023.10.02.11.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 11:33:23 -0700 (PDT)
Date: Mon, 2 Oct 2023 12:33:20 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Ross Zwisler <zwisler@chromium.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceeval: Fix allocation of val_stats
Message-ID: <20231002183320.GB1512616@google.com>
References: <20230927041901.07b756e9@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927041901.07b756e9@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 04:19:01AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The val_stats is to be the same size as the number of val types. But the
> number of key times was used to create the size.
> 
> Fixes: 8df588c6bc128 ("libtraceeval histogram: Add updating of stats")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
