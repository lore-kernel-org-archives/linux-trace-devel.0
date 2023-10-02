Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9297200A9
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:15:10 +0000 (UTC)
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7B3B7
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:15:08 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-3513c435465so389875ab.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696277708; x=1696882508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ppWQ5rxz8WXZM9nayEeravLOiEe3vxQ5h6cZfbzp5BE=;
        b=wc4FL3eFuq7R9hLwlFKRabTDdNhPF+Pck3PAMC/cZ9/NY5NKHKn+N+YJwrR9boHvF/
         Q0Q5FTzz4/TEQwlyNzqrDlT5Qgdycto8TJyih5Edy9sFyWLISMF+nP54+IVUpobQv/6P
         eOSp02FhAqHrQBiEeFxxBYIZQp2yuh++7caAXOOw1YUyDgqXtKlaD6cBRhtXSNB9UYcl
         JVQQUbtPUPw/33Yc2fs9+216ZM9CMTI3TNw0Wt0IusLJWzlb3LOhO3ampg/uLBRTsf/V
         xHECkQezitb1kRmY+2jE8Db9f10mfrZVEEXEDKjW6yMljByOoatUeaGwFImoSViJ0aS0
         Lh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696277708; x=1696882508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppWQ5rxz8WXZM9nayEeravLOiEe3vxQ5h6cZfbzp5BE=;
        b=kF56JhssablGss++GLF4eB7K5iuLOirV4IlkuFZ7W2abLTs6c4eKTKfL3dnnfF5Kca
         kpmDjsQaFy5JC4byIj5/lP+IoBiwp655k+YlyMwkP1GaPpDIxiMOuc9OMyNdQrsQP8rk
         cwKREnR98jxbpV+e6TxUrVVCa7G37qO1LuYDbKiAS1e5RrSlkhYYmk2BxWOWoBxW5cLk
         oqI4lsQ2SiopWorDpPuruXlShE4BO6qH4CC6sLzV/bqSSjxz/bWp7rjU8BsM5P1Zlyqh
         aUbgdr85ukIL0bz88L5hQ7d+NfkfjuEDZMX0xv+eDfLpJg5BfhKTxuRtgNM8AtjIxACy
         gyBQ==
X-Gm-Message-State: AOJu0YzZzTOIEirm5XMCsS8OWYEliEqNcGtVkbrS9Qkp+JSYhA/eHshK
	0Aqw9xmculgN4zb4TCFdhjNf0g==
X-Google-Smtp-Source: AGHT+IFkLHoxweTCGwS8w11G2GlBshoi5u5laBBzK80Vt/p64W3QcwTee6jlez/AlJPzDlFFG3jjhg==
X-Received: by 2002:a05:6e02:1d0e:b0:351:35d9:f18f with SMTP id i14-20020a056e021d0e00b0035135d9f18fmr540687ila.2.1696277707666;
        Mon, 02 Oct 2023 13:15:07 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id g12-20020a056638060c00b004290985a1efsm7122758jar.43.2023.10.02.13.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 13:15:07 -0700 (PDT)
Date: Mon, 2 Oct 2023 14:15:04 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 11/11] libtraceeval: Only do stats on values marked
 with the STAT flag
Message-ID: <20231002201504.GH1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
 <20230927123314.989589-12-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927123314.989589-12-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 08:33:14AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add TRACEEVAL_FL_STAT to perform stats on the value, otherwise ignore it.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
