Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA0647762
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vA88Rd35"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e4ad831b0so2695465e9.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Jan 2024 06:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704723907; x=1705328707; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vEPVWpDZLwhLJTnBtKVvXorOWiUtE5JNEnl/beWjKbA=;
        b=vA88Rd35Otp7k/s7z18yKMbw90MyZJ6/7kZ9vdTkak6PLRSC6uUhCcuJ2oAQYbsVhW
         SMe+vuGWeD8DLjriaYJwjthGBtCN0Ase/nL+GPPVrruApXu8BmhXRkx5ebUpXDNDSomD
         5s/KSdhQOOzbVWN7LaLoXGLL2+KtTZ3Q3DlgrckrfrXpLIZjJBoivsVYTnj9mwRRvP1H
         FGqDzNBExVUKv1b5KOlCaqh+vI3TrxmloMxn1D0bEPswlzo7eP4F4fZaAztOcowyJ2uP
         EGLt/1+OEGnDVGUhs3HjKHJ8ZSnQogap8jltCwibPClCFpRtcOou7O2INCw0ffm7JJzf
         7IRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704723907; x=1705328707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vEPVWpDZLwhLJTnBtKVvXorOWiUtE5JNEnl/beWjKbA=;
        b=N68+v1iVs6HMXR2kAgMs9axYy6GO/1cIdDanY1b2LTwgHxNDkicRBcd9PJOLTAl5+6
         sPIwpKGvjbbHJpGxGo2TdU6oW78w74Zwf8zLNV6Qj+XmP+jc/WEfLybp7gcqg27/kpaL
         ISNykPKrhPv2ckuxax8joBRKAxHmN82THCaacy/vf7bv1E8jztpIVd1sk5qywe4JsGHV
         mdlY5QyCzgYjec1ZYeAryzi1a2L2IkVoHJWPlQ0ZUG3IZe8xOAAMP/l4Ev7jkqCfbOz+
         XTwkb/TwgXZBLsboSh0Js1kvSnOVqgH1qZpz8l9wgkuWS9EzojSUPbHSQt01NUijQvI2
         aUbQ==
X-Gm-Message-State: AOJu0YzkMl247tUuccGXTCUqi3U3e8LNvxtfLEN5AYikAMjPgzHTbFJ2
	kd6fv70uKrMo+cgsoflBV29AiUC0ggQo1ZUPTpUFiDUE/vOt
X-Google-Smtp-Source: AGHT+IHlqP3Obd83cqbEOe4u/xoCWNWaxC/9DY8MMi2VRyFXlqxH7ztviUowX5rANRc+RsFs4g5fvg==
X-Received: by 2002:a05:600c:4510:b0:40d:3dbc:a870 with SMTP id t16-20020a05600c451000b0040d3dbca870mr1898860wmo.3.1704723907265;
        Mon, 08 Jan 2024 06:25:07 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id w17-20020a05600c475100b0040d802a7619sm11230086wmo.38.2024.01.08.06.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 06:25:06 -0800 (PST)
Date: Mon, 8 Jan 2024 14:25:03 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <ZZwFvyGvm0C38eBh@google.com>
References: <20240105152906.743d7e03@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240105152906.743d7e03@gandalf.local.home>

[...]

> +/**
> + * trace_mmap - try to mmap the ring buffer
> + * @fd: The file descriptor to the trace_pipe_raw file
> + * @kbuf: The kbuffer to load the subbuffer to
> + *
> + * Will try to mmap the ring buffer if it is supported, and
> + * if not, will return NULL, otherwise it returns a descriptor
> + * to handle the mapping.
> + */
> +__hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
> +{
> +	struct trace_mmap *tmap;
> +	int page_size;
> +	void *meta;
> +	void *data;
> +
> +	page_size = getpagesize();
> +	meta = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
> +	if (meta == MAP_FAILED)
> +		return NULL;
> +
> +	tmap = calloc(1, sizeof(*tmap));
> +	if (!tmap) {
> +		munmap(meta, page_size);
> +		return NULL;
> +	}
> +
> +	tmap->kbuf = kbuffer_dup(kbuf);
> +	if (!tmap->kbuf) {
> +		munmap(meta, page_size);
> +		free(tmap);
> +	}
> +
> +	tmap->fd = fd;
> +
> +	tmap->map = meta;
> +	tmap->meta_len = tmap->map->meta_page_size;
> +
> +	if (tmap->meta_len > page_size) {
> +		munmap(meta, page_size);
> +		meta = mmap(NULL, tmap->meta_len, PROT_READ, MAP_SHARED, fd, 0);
> +		if (meta == MAP_FAILED) {
> +			kbuffer_free(tmap->kbuf);
> +			free(tmap);
> +			return NULL;
> +		}
> +		tmap->map = meta;
> +	}
> +
> +	tmap->data_pages = meta + tmap->meta_len;
> +
> +	tmap->data_len = tmap->map->subbuf_size * tmap->map->nr_subbufs;
> +
> +	tmap->data = mmap(NULL, tmap->data_len, PROT_READ, MAP_SHARED,
> +			  fd, tmap->meta_len);
> +	if (tmap->data == MAP_FAILED) {
> +		munmap(meta, tmap->meta_len);
> +		kbuffer_free(tmap->kbuf);
> +		free(tmap);
> +		return NULL;
> +	}
> +
> +	tmap->last_idx = tmap->map->reader.id;
> +
> +	data = tmap->data + tmap->map->subbuf_size * tmap->last_idx;
> +	kbuffer_load_subbuffer(kbuf, data);
> +
> +	/*
> +	 * The page could have left over data on it that was already
> +	 * consumed. Move the "read" forward in that case.
> +	 */
> +	if (tmap->map->reader.read) {
> +		int size = kbuffer_start_of_data(kbuf) + tmap->map->reader.read;
> +		char tmpbuf[size];
> +		kbuffer_read_buffer(kbuf, tmpbuf, size);

It does not seem to update the kbuf timestamp. To observe the problem I did:

### Create few events on the page

$ echo 0 > /sys/kernel/tracing/trace
$ <read ring-buffer>
$ cat /proc/uptime | awk '{print $1}' > /sys/kernel/debug/tracing/trace_marker
<...>-2305 279515.453542096     print: tracing_mark_write: 279515.33
<...>-2307 279522.090413680     print: tracing_mark_write: 279521.97
<...>-2309 279522.960932976     print: tracing_mark_write: 279522.85
$ <unmap and close ring-buffer>


### Re-map again the ring-buffer to trigger the fast-forward

$ <read ring-buffer>
  before fast-forward kbuf->timestamp=279515453542096
  after fast-forward kbuf->timestamp=279515453542096
$ cat /proc/uptime | awk '{print $1}' > /sys/kernel/debug/tracing/trace_marker
<...>-2312 279549.725524688     print: tracing_mark_write: 279557.12

The timestamp above is a few seconds off, which I believe might be due to an
outdated kbuf->timestamp.

> +	}
> +
> +	return tmap;
> +}
> +
> +__hidden void trace_unmap(void *mapping)
> +{
> +	struct trace_mmap *tmap = mapping;
> +
> +	munmap(tmap->data, tmap->data_len);
> +	munmap(tmap->map, tmap->meta_len);
> +	kbuffer_free(tmap->kbuf);
> +	free(tmap);
> +}
> +
