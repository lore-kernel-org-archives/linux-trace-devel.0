Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2723A1F925
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 19:23:06 +0000 (UTC)
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53F6AC
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 12:23:05 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-7a2a3fb0713so3626239f.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 12:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696274585; x=1696879385; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mehFofHDU+9WxLWDpDqlxBKQuHujXv8Ng9CLaeIOpGg=;
        b=eoj/nu40J4X8DxHEryusXhqRy7lb8bznqBkG2h8TOydFU70rQ7PUxmQ99hNCAhUIBZ
         TF1zBwoGY1Id7sxFgWY3qIcqizXVTJsHnj2nTayYYZ9QRZoK42tOP+kcnDsPxQNnqQy9
         7Y2c02oo+sHjZt2/7eFIp7P6jw1deB4xTE51h29hxEDGFiBzOJrfz1YZuUvyzlW5c1fk
         WOjXDSfEpRmI1+g32MuWTFoqjXrELbYZgjuWs4ximrr14oroRnGbTgBjYJhuhH0MzOZe
         CY8mQh+/w3S0MZ3cCQ61oVlO+MxWtbgWds9TobV/0yqclZTcADcoAm7qHSSSWN6H2vkZ
         GEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696274585; x=1696879385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mehFofHDU+9WxLWDpDqlxBKQuHujXv8Ng9CLaeIOpGg=;
        b=TyvBIAxh3lo0VMzFuc9zapQZq3jVg17tm/5mrqXro71UQ6tEqaD8veKOU7zJ6h4F8q
         wCeRIiLxXnorD7S7jlxuZXUrpLdaQGpmY7gedRPNEwFyd05t6567SK3VyKkrR6SI+f+1
         tk7TxFr3gkN1bO3Jr67zxjy4lLgLA6rlqqkANh+x75v6GKzXAXenOQQXzQ4pXOyuFTOS
         NeowxI4Kho53MH4pBI3LgVnSshG2sJdNuCQDWwzYPxnKVD0kJL9CL0hG1zZRG2AJm9Bv
         syy/C/wPfcsfA8HdlNQ5YX8DFaG7Ow+9eEuRkvj2BBSmM/ugdcytAh4tnAGOHDifSSyM
         BuVg==
X-Gm-Message-State: AOJu0YwGMk8oGz1+Y8H16rngHiLjWEjiJbmhAc4RZ6+f1+3vW0v6OUzV
	Ss0cScmkdv1Tau8SZMjGgO5HDmfB5JTK3aAdEzTUJA==
X-Google-Smtp-Source: AGHT+IGn/AXSMSd6fF14eu/g37e7h3R95jR9sx87L7CQRXzSHyxcVA593fF+3oRBh+z2vBWvcYxckA==
X-Received: by 2002:a5d:9cd8:0:b0:78b:b892:e334 with SMTP id w24-20020a5d9cd8000000b0078bb892e334mr14653694iow.11.1696274584893;
        Mon, 02 Oct 2023 12:23:04 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id w5-20020a029685000000b0042b62a31349sm7159968jai.146.2023.10.02.12.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 12:23:04 -0700 (PDT)
Date: Mon, 2 Oct 2023 13:23:01 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 03/11] libtraceeval: Add
 traceeval_iterator_results_release()
Message-ID: <20231002192301.GA1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
 <20230927123314.989589-4-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927123314.989589-4-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 08:33:06AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add the function that can release the results from the
> traceeval_iterator_qeury() function.
> 
> Currently, the user must use traceeval_results_release() for the results
> returned by traceeval_iterator_query(), but that requires the caller to
> also have access to the traceeval where the iterator came from. There
> could be many iterators and many traceevals, the user should not need to
> worry about which one goes with which.
> 
> This new traceeval_iterator_results_release() will take care of that for
> them.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
