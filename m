Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8218A219F9
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 09:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="me4C5bMY"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40d60ad5f0bso15434755e9.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jan 2024 01:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704446277; x=1705051077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XKXk6YU1OhYqKA8wumodgy1CMsyzMv176cXfS6QvBzY=;
        b=me4C5bMY5g/Hih3E7Gqd/uuyY2tNQTInoeXD85871NBTg4eoUbFcCQ0O9D/SKpCz6o
         ilcA58c1hmLT+E7/ELERs3T21bsjLXx9rxpmbVT+apxWqrIZ6e+4ArZ31uwdGxULFSCq
         u1jWJyuP60PaZJ84yNSIOBZN9UxchOsGGLnpX8d2sJ/Bc3f6ayv2xwR/ZjAr3Hm2Y1BZ
         kSi+NZP0evVCvG+SX0LKl/cQmpeZ6II1Vd9Q+N6Ct1FDFmSsMvSAYQQy9opJhWT39bwT
         9Is9uCPmqhXmSDZ6kskwl6nZLg/W5aYqFa09Xry+Cw5DE9ZfiXTjgyEOyyic3wY7gNYJ
         LoPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704446277; x=1705051077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKXk6YU1OhYqKA8wumodgy1CMsyzMv176cXfS6QvBzY=;
        b=lYWYLrcWmR/5+kUR6A28O9baPQ1LdcPSOSob1ie4g7GXnUouDalJ7GRWMRoAtpqhN3
         NkQkLIhsX+QP9XxV26HOkv88n9XLdYK2rviq4pBt9C8oKa+OPOGdNXrZ51iAK1YwjZdB
         yM4mtzoalBFVVqOCiCqrAiQhESaR8r+JB54IEtbtGT8iZLgv7Ly4hlDp3LCiAiiKE5NI
         BK1rGD6GszO1RYThNYaTZdLIg7SjFVQBeNtwlnNDP1n+2fzA/eTqdDQMvhH/PhwR8r7L
         E9c1w7rOCdsrMtJ8JI/lhZZJvZPoQrKWPyyG6n0OCpsOnpc/JsSXKpETK0di5Zd8xkZQ
         K3Sw==
X-Gm-Message-State: AOJu0YwNbeA5/GrYkl7axfLZXY36Pw/I7ypBCMZ8IqbKAwSBtuImtb5s
	3ealbqwtF+Nl/1ElfNnG0qECEHDIU5dS6Ejip5UXlIH3KLs4
X-Google-Smtp-Source: AGHT+IF5aTPQEHvkHzRsoKJd3C/p9Ks7bcr8TgiswvHR4W1UZ9wyGdPlnI71rpc6asjg/jzcNAezlA==
X-Received: by 2002:a05:600c:1f88:b0:40d:5c89:9dfc with SMTP id je8-20020a05600c1f8800b0040d5c899dfcmr1120218wmb.182.1704446277513;
        Fri, 05 Jan 2024 01:17:57 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id n4-20020a05600c4f8400b0040e34ca648bsm971493wmq.0.2024.01.05.01.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 01:17:57 -0800 (PST)
Date: Fri, 5 Jan 2024 09:17:53 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <ZZfJQTOyl0dHiTU-@google.com>
References: <20231228201100.78aae259@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228201100.78aae259@rorschach.local.home>

[...]

> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <stdlib.h>
> +#include <ctype.h>
> +#include <tracefs.h>
> +
> +static void read_page(struct tep_handle *tep, struct kbuffer *kbuf)

read_subbuf?

> +{
> +	static struct trace_seq seq;
> +	struct tep_record record;
> +
> +	if (seq.buffer)
> +		trace_seq_reset(&seq);
> +	else
> +		trace_seq_init(&seq);
> +
> +	while ((record.data = kbuffer_read_event(kbuf, &record.ts))) {
> +		record.size = kbuffer_event_size(kbuf);
> +		kbuffer_next_event(kbuf, NULL);
> +		tep_print_event(tep, &seq, &record,
> +				"%s-%d %9d\t%s: %s\n",
> +				TEP_PRINT_COMM,
> +				TEP_PRINT_PID,
> +				TEP_PRINT_TIME,
> +				TEP_PRINT_NAME,
> +				TEP_PRINT_INFO);
> +		trace_seq_do_printf(&seq);
> +		trace_seq_reset(&seq);
> +	}
> +}
> +

[...]

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

Could it fast-forward to the event until tmap->map->reader.read? So we don't
read again the same events.

Something like

  while (kbuf->curr < tmap->map->reader.read)
  	kbuffer_next_event(kbuf, NULL);

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
> +__hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
> +{
> +	struct trace_mmap *tmap = mapping;
> +	void *data;
> +	int id;
> +
> +	id = tmap->map->reader.id;
> +	data = tmap->data + tmap->map->subbuf_size * id;
> +
> +	/*
> +	 * If kbuf doesn't point to the current sub-buffer
> +	 * just load it and return.
> +	 */
> +	if (data != kbuffer_subbuffer(kbuf)) {
> +		kbuffer_load_subbuffer(kbuf, data);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Perhaps the reader page had a write that added
> +	 * more data.
> +	 */
> +	kbuffer_refresh(kbuf);
> +
> +	/* Are there still events to read? */
> +	if (kbuffer_curr_size(kbuf))
> +		return 1;

It does not seem to be enough, only kbuf->size is updated in kbuffer_refresh()
while kbuffer_curr_size is next - cur.

> +
> +	/* See if a new page is ready? */
> +	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
> +		return -1;

Maybe this ioctl should be called regardless if events are found on the current
reader page. This would at least update the reader->read field and make sure
subsequent readers are not getting the same events we already had here?

> +	id = tmap->map->reader.id;
> +	data = tmap->data + tmap->map->subbuf_size * id;
> +

[...]
