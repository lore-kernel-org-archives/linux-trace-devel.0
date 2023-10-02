Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035291F93C
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 19:45:25 +0000 (UTC)
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F0F91
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 12:45:24 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-79fe612beabso4223239f.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 12:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696275923; x=1696880723; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TLc/DJ17HxEnPbAylmnJw+/JvkOs+sNXZpf7FMCqML0=;
        b=o+hSeUv6ukP2dq89ze5kycpBXMj6lzdt82MFsmgA2vRbidgoQgOGy4WHou6Xy8QHU1
         9YsdfKdh6t4WmtIjd/kR2kMaoPQVaQVtbct+/zwbd6GHjZzLBjwXV/rCmkGnQpa6eBjO
         +F6+6OzoInfBVIrnulk2w5IyQ8ddYX5uYjiEoLfHZ2rnOqbzJeFSuQ/nf9wvEpsFWezd
         JdmTvio4reGiH5dtBHDyRFkSf70Pz/1OD7CX5PvcuQkGNcwz7a14dMNnGPhb0wJ+ojpq
         kJFWYIzeozwLHTa31IUbeNtNCxL4gucvlqCgI2WRc/OoKNeDKsuZ9inDm3wNNv/EThGQ
         mXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696275923; x=1696880723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLc/DJ17HxEnPbAylmnJw+/JvkOs+sNXZpf7FMCqML0=;
        b=WyVlVRvBhvd9PzSxyJPfCVIIk7zAzQIU/MmtJXIDwv+cVaThluiwEcNoqR11LhuoGu
         k8rZVD9lU+B8Z5VKwQOl5uds2RHhhoDFgXnXmCxPgg4upTOgfBBP5oAkQZsmg0MckMB/
         leCmCoNAvB679/3CLyU+ZNXsGZEzQQNfvJfBxTkUbY1LTHbQCTRMKs5PdWPoBYsz09Yz
         gXKQODyf6lk53WccgbvvuSabXNRnx8AE2iZ42U7Xf2SgJv+Xzx6wbocWx16yi1G45AIr
         8AL0GgE6QWJhzgLwnLbMhhz5OgkPNHpAZkQD7Xhpjj7/l8tr3i3AF1cZt01p5pezB7QU
         6XdQ==
X-Gm-Message-State: AOJu0Yw1KTZiv2zN6nUw7oqhmX0sYIIXeIzqJoYB00/pO0LhvSuZaJov
	wDGMxzcJlq6Vm3LGR/X6pTItnw1jMUYl5HGJOplC4w==
X-Google-Smtp-Source: AGHT+IFD3cA7CmimZdVzAaNgLkD8gF1U5B0XF+DFCE8fBwwPFjEpnZo3ZNRIwyQEr0P9lA/bgk0ouw==
X-Received: by 2002:a05:6e02:1a01:b0:34a:c618:b904 with SMTP id s1-20020a056e021a0100b0034ac618b904mr17023712ild.22.1696275923337;
        Mon, 02 Oct 2023 12:45:23 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id s5-20020a02cf25000000b0043321a50c29sm7040676jar.93.2023.10.02.12.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 12:45:22 -0700 (PDT)
Date: Mon, 2 Oct 2023 13:45:19 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 05/11] libtraceeval: Add traceeval_iterator_remove()
Message-ID: <20231002194519.GB1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
 <20230927123314.989589-6-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927123314.989589-6-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 27, 2023 at 08:33:08AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add an API traceeval_iterator_remove() that is safe to call in the
> traceeval_iterator_next() loop. Currently, traceeval_remove() can also be
> called "safely", but that may change in the future.
> 
> The main difference between traceeval_remove() and traceeval_iterator_remove()
> is that that traceeval_iterator_remove() will NULL out the entry in the
> sort array, and use this in the other iterator functions. If the entry is
> NULL, it will not be returned.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
