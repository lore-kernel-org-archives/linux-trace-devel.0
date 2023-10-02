Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FB51F19B
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:25:50 +0000 (UTC)
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABD9D3
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:25:48 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-351574aca7bso500965ab.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696278348; x=1696883148; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0LCtOHrDy/EPRvVdNfDcTjQ237f3VhKgympTLJCpl+8=;
        b=Z4YV2uvPFYICN4jCgmem1LRpPQrXQdY5FDXkMbkeq5Ikwpf9BuIzRe2A7PY6inS+eY
         5hMSjUtCje9swc9DpglW3egmmD04q53W30hPiBfkQ7o7JUb3baVH+VJ5rsvi6t8HWrTc
         ddSBq5iAAbW0wROdhAW6byWq/ITL/7qvMuWaYWckGtbBn1qWlK9EJ5VJNsw5s7JyT+1J
         e+SU29JHr5fcll3QYQ481IBza1z9n2vtBFLirMpTzvEp576LNoejiwrP/nWpKSu1X8TR
         0FBjpsAhVpV3/Y1Ey1hoDdlq2PXt9DBTkC2AIj+cO6F7SPVufvpRNW1PBQJYv+18fctv
         isAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696278348; x=1696883148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0LCtOHrDy/EPRvVdNfDcTjQ237f3VhKgympTLJCpl+8=;
        b=fIm3ryRUzdcwG54JLI4ZNuo2PiSWuY2ge2qEYBQoJLSiMc0ZkECZJZaCIMEUbr0TkF
         how3ii2qqRKQNcGIOdJX13bKm5EXTRF5UMNPIACtH6oChTUDw3/1uNnfd6aNvOXggOfr
         oVTygmwaWdYQoVrBp01e2IH/WOxj1Ey908/EaeegLsV1Pr1mPCfyRAMfe+K6bCrbJE4p
         nh1B+sCVVX2hSiJZZvLHeovEOd03lpo4twyUHBvwIKPr0WTigX8hglWDSG3miZ7D11rq
         Nt8RypiD0/akDKjJrpl6cineIH7UlxwZdvdj9RqWQH1tsukzr4ZP7qmZUVpj0nQdx24J
         k3mg==
X-Gm-Message-State: AOJu0YycfqVm8gyEMxwwUP0Xz0ocxNqYxL3/FV749SW1jHjiUlOLiCau
	+NaCE0nBFmsTSZkVGXoVJgs7Qw==
X-Google-Smtp-Source: AGHT+IHNG4TbKXMlCn6i3iJorUkafe/fnlxup9f56k79OVZbFLrDnzvMy6uybTdDOOH1a6s/YaYKow==
X-Received: by 2002:a05:6e02:1054:b0:34f:c9b4:5f9c with SMTP id p20-20020a056e02105400b0034fc9b45f9cmr11254726ilj.31.1696278347928;
        Mon, 02 Oct 2023 13:25:47 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id o4-20020a92c684000000b0034fd416a166sm4655653ilg.25.2023.10.02.13.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:25:47 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:25:43 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceeval: Add traceeval_init_data_size()
Message-ID: <20231002202543.GJ1532181@google.com>
References: <20230927090904.396273fa@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927090904.396273fa@rorschach.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 09:09:04AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> In the future, the traceeval_type and traceeval_data may need to include
> more information and be expanded. If that happens, it will break backward
> compatibility for older applications using the newer library.
> 
> To be able to handle backward compatibility in this situation, have the
> traceeval_init() turn into traceeval_init_data_size() which takes the
> sizeof struct traceeval_type and struct traceeval_data. Make
> traceeval_init() into a macro that calls this function passing in the
> sizeof(struct traceeval_type) and sizeof(struct traceeval_data). This way
> if the sizes change for either one, the new code will know if the
> application is using the new interface or the older one, and can
> can keep the older one still functioning properly.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
