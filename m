Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825BB23750
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Oct 2023 22:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEKYcWer"
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E51719B
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Oct 2023 15:10:12 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-79fb78e297bso17266639f.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Oct 2023 15:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696457411; x=1697062211; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RMX2MVauVlyCxUZ04E8b9T79KRPqwAd7mtQrIpJyOew=;
        b=HEKYcWerUuxCsWqAR1aIieZKXD9nZrcvhN01uc0g3azBG9nyFzmyEB2jpS1z5uRcRF
         BeJKbbyKZVhYbB+tE/UlHt848KZVGw/fyVMOS3NzxcMJifsTTRzIze8uEqK1Bwjdnkso
         v3SA972rqT0gpbGbTq0GsEeegoQf3Kk4TztJ1AXqGVEWNWxWleeGlZU+d0Sfwx5Y53RC
         3J0LjBstyCw5ohpdAxumgC16vIjderlQbEe1fsoT0bLrQV3ZJ32+oW4J95URfa54tXwE
         CxO8fd6fAPwwC8Y8EfqP+re4k7JHEehlQmZ1/QIHQfZ/hje3lLfSZM/YUKWAbdJktdbC
         f+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696457411; x=1697062211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMX2MVauVlyCxUZ04E8b9T79KRPqwAd7mtQrIpJyOew=;
        b=M0Ty5QfrQQTeuMMWdknsKcAMZIS50s+M05AcRKCu6cI+JxujmjHOxw/Tww/R+EyV4j
         QBhuRatIAk8ZqmsA8A8ershW+0Pfv50apv4AepdcPENJH1O7kpBY9arNHKOeCbUW02zl
         ezPZ3RxykdJrbmaP7uYmfxr6RRfjNmKEV9OWceYLtNhBqykzGev8h2JzhUNDs2nzC9WQ
         xfQVwon9YxekV8ibxaSRMtNzy5tWAMYyVxeZFwWGkWFqHtg8PO581reFVCbCxUGkwGT3
         TWVRfXkQq3teBg1WSDFdmxE/LQp+lpScUShPdx2sv9K6iA7zTQvIHT1Bi9/PkQMaiti+
         8fgQ==
X-Gm-Message-State: AOJu0YweDS4G/JQdBjWznEKiGYM/4r4jxnOr5P4xMSZY+v98bmKmNQdl
	qD83ZxSkvMlZe0dm3lh6lzgWmA==
X-Google-Smtp-Source: AGHT+IFZriaNMXqcHMv0C08azO5JE/K3aZcoobEVLzwql/k6rXBCFJO64S+4p0iyyUg6j+wVcnvSfQ==
X-Received: by 2002:a5e:de4a:0:b0:794:eb37:b0c4 with SMTP id e10-20020a5ede4a000000b00794eb37b0c4mr3036813ioq.21.1696457411381;
        Wed, 04 Oct 2023 15:10:11 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:3bd3:cc5b:6385:12b2])
        by smtp.gmail.com with ESMTPSA id h8-20020a02c728000000b0042b0de0b976sm58850jao.154.2023.10.04.15.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 15:10:10 -0700 (PDT)
Date: Wed, 4 Oct 2023 16:10:07 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] libtraceeval: Use name for type look up for
 traceeval_stat
Message-ID: <20231004221007.GA2699138@google.com>
References: <20231004180523.381cca3d@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004180523.381cca3d@gandalf.local.home>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Oct 04, 2023 at 06:05:23PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The functions that retrieve the traceeval_stat currently requires passing
> in the struct traceeval_type. But this is fragile, as it may not be set up
> properly. It was originally done that way as a "fast" way to look up
> stats, but in reality it will likely just cause more issues with wrong
> types passed in. That decision was based more on defining policy which the
> library should not do.
> 
> Instead, just pass in the string name of the value type to find and
> retrieve the traceeval_data value from the traceeval that way.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
