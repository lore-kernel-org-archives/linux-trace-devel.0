Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED336AF1
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 15:39:41 +0000 (UTC)
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E552A6
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 08:39:40 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-3512c43adebso3666635ab.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Oct 2023 08:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696347579; x=1696952379; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ad/beiwCV051h2gcyif0EfNS/EVmCO+dHX1Kv6TLQE0=;
        b=GqMkih5XXAi2vLZFSc7bf/zNgg/fRPgJn0tvO0LQZ3n9+6DbH4ldC2jrZPa8M1nRlw
         CbAtfBUvZDuUEmhJtYGsy9E2KeUmPwzapQghPfqj71e7YGo0aAmYLLlI9Vp6Xh94rYvj
         /RISIqlYp+DRahe68NhG6RE7oD7htr6djQZXMpEUyv/Lr+dxPYsQDUEQ+uwv3+XpbuAb
         1rj3ZpRIjp60AVgjBb6Q9hB2OvvIe4+UgqlIkxTsDRmcp+vF1Yybac1f7rjUgo/2oika
         cN3mID1j+KvHhJo/YYzbF6VzWOtjszHD/N1ZCs3J1AfYVVgic5yeDGa9h7ZD368PsvtR
         k4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696347579; x=1696952379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ad/beiwCV051h2gcyif0EfNS/EVmCO+dHX1Kv6TLQE0=;
        b=fCRWBxZk2msdt9XZjj1zKWHXgmOBVvRTyxbvS0o/7o3HlY/pvZ5e/vrU65NIHkVWAc
         yzX/iSfkiCDUxkHEVwVCKMBf8g0jc6svFoAelr6Wf20/H7Ob1DvYOmGCp6yFe+lbG+Ji
         CO3UKt57h0pNEpvEcVtF2+sQMf+6DUpn/P8I1sQ1CwObXj0Su4sXPuJJoIwi3DPrKBLe
         nvBMx+L7A1g9TX9PEv3i324fgLpyMu0OtNMJUuipwJWGOWY4A7ZWQ8wir0bs/vJJQKhi
         8SSARAhNzxyVi63fO66o9UXAGf7tiZlwEp4F4+lxkfxbQsxan0AwPP/pg8oe8FD8CL9A
         JTwg==
X-Gm-Message-State: AOJu0YysONE8C7LLVNnn2dywDVSde3XzrZmPLA+EXXZR/WCm0Qu1OQ6i
	l4XEHSSevfwA8g8bp9P4QUm4dA==
X-Google-Smtp-Source: AGHT+IF0LMl70so2DLeS2bPONrj6UtaD4LfpHai8Dx3h2dFb+cH/Nr0E4dbEmXQ5qmxk9Slk/wp52Q==
X-Received: by 2002:a05:6e02:1c4d:b0:349:2d48:66ac with SMTP id d13-20020a056e021c4d00b003492d4866acmr21737905ilg.12.1696347579572;
        Tue, 03 Oct 2023 08:39:39 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:d5ff:6f50:bbbd:a922])
        by smtp.gmail.com with ESMTPSA id h10-20020a92d08a000000b003526f14513dsm442860ilh.7.2023.10.03.08.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 08:39:39 -0700 (PDT)
Date: Tue, 3 Oct 2023 09:39:35 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 2/2] libtraceeval samples: Remove adding
 TRACEEVAL_TYPE_NONE to keys and vals
Message-ID: <20231003153935.GD1935474@google.com>
References: <20231003140802.1139616-1-rostedt@goodmis.org>
 <20231003140802.1139616-3-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003140802.1139616-3-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Oct 03, 2023 at 10:08:02AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Remove the TRACEEVAL_TYPE_NONE in the initialization of keys and vals in
> the sample code as it is no longer needed.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
