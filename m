Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B615A0FF
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003585; cv=none; b=EPmndEmGMcLUumtiKK7iTWWXPaIhl++1ew5jeU6qoKjFNyu33KRfaK4Uw4z5KJlmXrahuo85pQjEuAhY9QLj6vZ9GN4pPzPLA2Ei7rvD7g79ycjK39ZL/u5bZZl8qPLHA4UdifTocqAcx0BU0LnxP+HmF/9PIDBEIwBfaOC+7aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003585; c=relaxed/simple;
	bh=d2tWdFks1GfeTjrC+rzd+PzTCnzAhakmAFIEFJTr7Pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gb49YM+sD4BLlqoO0jxG9NHcM2N5zTtASIOJKUjVPdxCFf2IEOrmbbselykvdiTSyMSOQmJNjNAS+3IYHP1T3MyjH86l6eSwiqNkzo/c5Wxd7o7kIOPv94DCSZrzOVYdXlpn0KBZiYQkLaf2ayqa6T6JNSKpXeszOc26mjwDo7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FOoMln+a; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FOoMln+a"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40eacb6067dso23038425e9.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 01:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706003579; x=1706608379; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=14o0tH9iKX9/TQAOIUTm8waSckmUtyi9fGApL5crdUk=;
        b=FOoMln+aJRrWMwwn0krmN57ljYpd7kk5NEJ9UON+SnTjIrZTEgP272zxIfHpaUwLdX
         JbvdIjUUwq3ny+ByYGIlO335n1Lzb48w3VyJMdij+mBuqjQsNFSlmzFhEIBNc4miXS5Y
         W3zQFhJM3BgVHAD7sI8CfeQZGrC2K3nPFM7vIOGqkauoXXFjNxTaZ5MiKRo1WgP8SdAM
         N/jYmpHpBJwV30DLReQzKz9GhApiQZRt0NhIANlpt4iSZzwhw9lsZtg0T9zmbZXBSRMc
         zkdjKfVgIN1d+QwutxTKHZxeLvaTnJ9JMTSClX0CDFuH1aRKSso3CsAJ0T+wNfbR6E4H
         WFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706003579; x=1706608379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14o0tH9iKX9/TQAOIUTm8waSckmUtyi9fGApL5crdUk=;
        b=caEzjeMCtGNcF9l999hFLj2pNKuE5b5YQjJG8gnlUJuG+xfNaHQws0ezHXzpNZ+Uez
         myDUsSJhe+Cyflen5gB/EGvJevGskoqffaC58yE/oJQAQWqQKkRxsKyyVgskyX/tJpxA
         ChPezWPI/npQ810lyuh5s7rX0tP5Pbybvv/poGRgOky66x3djeBkGGpUQTmQDH6LsF/J
         jCNV3FSBvdpfOYYFnMCPcYnWbRrllrw5+29gRthxmyEtbxBJRxv9765YEwIBllZVmbIM
         5gGQRIO0Ad9q3aQ0l3axsWtvCj7r3uzDMEEfTzfCwoM+b0hKApeTBD5IiEkIv3yFqC95
         5ObQ==
X-Gm-Message-State: AOJu0Yz8hZjavlINoAqFgZpyaNLz0mos6tKkNXuFZpZRJ1j2Qbcc7vkm
	TttJMPiLh3bjZUOFuNFMk6so92M1Nej3PryGv5I6bNsItc4Rb3zdTPk3a9+ipM/fW6J+KaoGNgZ
	GZw==
X-Google-Smtp-Source: AGHT+IFThoZiX8uzKfoH5b5sIDQHJRCLl6wp77b/mxv27gTF3Hjps8uK4aAQHFcVoOrD8OkQJsdFYQ==
X-Received: by 2002:a05:600c:3d15:b0:40e:a5f0:d0c2 with SMTP id bh21-20020a05600c3d1500b0040ea5f0d0c2mr193663wmb.126.1706003579502;
        Tue, 23 Jan 2024 01:52:59 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600010cd00b003392c1f40acsm7234451wrx.28.2024.01.23.01.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 01:52:59 -0800 (PST)
Date: Tue, 23 Jan 2024 09:52:55 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <Za-Md51snPcIoYFn@google.com>
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
> +	}

We're fast-forwarding tmap->kbuf here. But in tracefs_cpu_read_buf(), we are
using tcpu->kbuf. So overall, it seems this has no effect on what will be read
later.

Sorry, not sure how I missed that when I worked with those changes before.

[...]
