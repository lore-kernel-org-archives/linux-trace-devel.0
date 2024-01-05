Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50C0219E5
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 21:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w675TqPr"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40d76923ec4so18746765e9.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jan 2024 13:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704488494; x=1705093294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0sMf3KYFhjl9ym3/DZZJy07i8GRqMBRgVWcshg9PdFc=;
        b=w675TqPrKc2kmQFfB7hp7p1/WbByCye8K/2sHbxPM99a+wyK2yo4WK8Zt7p96lbMP6
         YcJiWfBt2ikM61eqY2KHMCLB34AQGZC1mx4Kcv5UwppEn4wb4W/I9FItNQUFa2hOwNt7
         AhLe8hJgPaXYFd1MCM4FXWZjCFKdttus4mh85xDWYr3/KH8dJ/6yvrDWTiVNseqkK0vx
         R1I/kPiVrJG6ZMV7LMC+TE287UFqzQ6z+7VT7Oj8MvYbYk2QnMtHc8d4futoBNuZjmD9
         mLf5IOZ5qnGC9CrAAwHcKuY0OjDBaSjqff81O4tNNERIDx4nKb51TXo2ny3RuYdcBEN5
         dweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704488494; x=1705093294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sMf3KYFhjl9ym3/DZZJy07i8GRqMBRgVWcshg9PdFc=;
        b=lNuyywpv8s3NNiA8YOv3m4oBzhmRhkP8/WZuEFl5ImmkCnUvSULTbkIpJngwq6JP4b
         grHIPbIbThH4nE09tLD+ZxmoKWVIYOCR9HyoXvjKDiLCrF2fbqHZ9LexlPjUnAXC7MaZ
         5tmfwZ20WuLOiPi+aN4NrcRAI0hK+jJ8dd1WtKnTeCqhZyHdPkxpzltjm/wGk8ETfDBM
         c5s5fCKEKr16y9w9Sz6FbWwBsuTNYXnhIdu17j+CO9SWxy1AA9ccbjQV2OJ09k9BHYiw
         ogg+slu7N6t7JdDMnUy4kKP1woWcuk/TVH9e0JVXgTaSy55O5S8WbhPWpNHW1vomEH9Q
         aMCw==
X-Gm-Message-State: AOJu0YzJ/YQJR3EyYxra7L+QdNmbA2zk+mtHvRw8zFRzcBoRQ71ur3TG
	kRT5N7bo4SjzihJspw8NIyrR1AB46fd27AJPkafYBtGcodTS
X-Google-Smtp-Source: AGHT+IETOMz28bscDSfMv3Sgo/HbvNgu3CPi+5mYjXttllW2LDiAcAzY6HcX9OMIWmbYieuOFuN+Lg==
X-Received: by 2002:a1c:7c18:0:b0:40d:877d:ca1 with SMTP id x24-20020a1c7c18000000b0040d877d0ca1mr49093wmc.54.1704488493944;
        Fri, 05 Jan 2024 13:01:33 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id hn3-20020a05600ca38300b0040e398f8cafsm2325833wmb.31.2024.01.05.13.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 13:01:32 -0800 (PST)
Date: Fri, 5 Jan 2024 21:01:28 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] kbuffer: Update kbuf->next in kbuffer_refresh()
Message-ID: <ZZhuKFAkDHRLHlwt@google.com>
References: <20240105194015.253165-1-rostedt@goodmis.org>
 <20240105194015.253165-4-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240105194015.253165-4-rostedt@goodmis.org>

On Fri, Jan 05, 2024 at 02:37:44PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If the kbuffer was read to completion, the kbuf->curr would equal both the
> size and kbuf->next. The kbuffer_refresh() is to update the kbuf if more
> data was added to the buffer. But if curr is at the end, the next pointer
> was not updated, which is incorrect. The next pointer needs to be moved to
> the end of the newly written event.
> 
> Update the pointers in kbuffer_refresh() just as if it was loaded new (but
> still keeping curr at the correct location).
> 
> Link: https://lore.kernel.org/linux-trace-devel/ZZfJQTOyl0dHiTU-@google.com/
> 
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Fixes: 7a4d5b24 ("kbuffer: Add kbuffer_refresh() API")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/kbuffer-parse.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
> index 4801d432c58c..1e1d168b534c 100644
> --- a/src/kbuffer-parse.c
> +++ b/src/kbuffer-parse.c
> @@ -299,6 +299,9 @@ void kbuffer_free(struct kbuffer *kbuf)
>  	free(kbuf);
>  }
>  
> +static unsigned int old_update_pointers(struct kbuffer *kbuf);
> +static unsigned int update_pointers(struct kbuffer *kbuf);
> +
>  /**
>   * kbuffer_refresh - update the meta data from the subbuffer
>   * @kbuf; The kbuffer to update
> @@ -309,13 +312,24 @@ void kbuffer_free(struct kbuffer *kbuf)
>  int kbuffer_refresh(struct kbuffer *kbuf)
>  {
>  	unsigned long long flags;
> +	unsigned int old_size;
>  
>  	if (!kbuf || !kbuf->subbuffer)
>  		return -1;
>  
> +	old_size = kbuf->size;
> +
>  	flags = read_long(kbuf, kbuf->subbuffer + 8);
>  	kbuf->size = (unsigned int)flags & COMMIT_MASK;
>  
> +	/* Update next to be the next element */
> +	if (kbuf->size != old_size && kbuf->curr == old_size) {
> +		if (kbuf->flags & KBUFFER_FL_OLD_FORMAT)
> +			old_update_pointers(kbuf);
> +		else
> +			update_pointers(kbuf);
> +	}
> +
>  	return 0;
>  }

I've been trying the new stack but I see some weird unexpected events:

$ echo 3 > /sys/kernel/debug/tracing/trace_marker

<...>-5 44401.178473328 mmiotrace_rw: 0 0 0 0 0 0     // I clearly didn't enable this event
<...>-208 44401.178473328       print: tracing_mark_write: 2


Looking closer at the kbuf I see before the kbuffer_refresh()

  index = 244, curr = 272, next = 272, size = 272, start = 16

And after

  index = 280, curr = 272, next = 280, size = 312, start = 16

Could this index be the problem as this is used in kbuffer_read_event()?

>  
> -- 
> 2.42.0
> 
