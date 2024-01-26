Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB3C250F1
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 22:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706307989; cv=none; b=qV8McK1tChVBWRwAfPYTXLPNxlEYUb3IhjirmcJcyqLaMhceAbG3zPS+vp+g4R67m3suWvILjDidv67r283mvFP61uRkvPhuZ8CMg25NddfOW88+bwO3V0eqiivSwth3Xr1j7kChu0vvbIIg1bQLBbVYkEPqbISZIJHiFo+BEIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706307989; c=relaxed/simple;
	bh=ulYxyMID4hoDqqkZq7ZMib690LO/V3+HiOYKu4iA5EY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A6U85P08jjo6n7eU8TF6E/iAmf4GG3Ai/N2TOCrEx44nJ9O9uIKubDAT4S2iVFQH8MTVHaAV0i+61I4b9cct+vllZo4kzie7o0ahDnhxdGQ8tzbt/Z3Vdcs4/3SfIYJOaR8iuYCwk0vyjLt9+TVrKQlGbSZkVK70mtlq4aIUook=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G0b+K8dK; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G0b+K8dK"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40e76109cdeso18665885e9.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706307985; x=1706912785; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T7RgCCRFdykhHgupnFCoE0SS5Tr46EimKI36cb0Txx4=;
        b=G0b+K8dKSaXhtj/LF1iMD6wZqs1UnX2DuWYXjXfIXukLmUdh9ieE9HvalEHFleujju
         hWEUmLs1vA9PrCLZLauOgOch+V9E4Shox7k9C9vcHDvmYJh6vIYYFcPBfE9MLH7hRhyg
         H0U6DbaBApv8Z9eONS/HV+1Qa6sUSQ6dbIJ9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706307985; x=1706912785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T7RgCCRFdykhHgupnFCoE0SS5Tr46EimKI36cb0Txx4=;
        b=opma91P+bh9lMx1YcTQe4v2q7F3ZQB1oy4Vt8PJtdMhA0dnB2ybX7tQE0zWc/zeuf0
         yugYVxQmHq8OqF5wYdbAaQoAubvZAM5hyUo2Sw1cVMwcf+Us0Qv05vtDJ3X1EfjI+AC1
         izXTZg8T+kBFO+hdGY/fJjmGH2P7eGiZqANbnHRHPqYAJ4FomK1kvif1w/UM6gNlRR27
         e6puKsKIFQOI/zxmsaujb57X3Qsb7Ej4IrXOfFt93XdKZYOLDudi/UFyGIdwQQrMKDQF
         HYIFHImK9IOCSvCAUcu0dvUxrCeUW1uIKUS37Lrp9mvKmR8K+2KchmgGzhaGLusTJUCj
         ZoNg==
X-Gm-Message-State: AOJu0Yz1UPwLRVUskvRL1B5CSV6LUwo6DpyMH/L4JiybKUH5eXZjR3mW
	NOnkBiHoMheRNSP0+Poo8GevU3Rk+Wakn5XW8VfcyvsVf+PP3DxvFaBna40w3YH/Crnz2/agpVn
	D5KOcGw==
X-Google-Smtp-Source: AGHT+IEv32LrPIzOTFISuAY+89YClhMrbXND1uhIiGKe4qN+q9+WbLEUN5K38qDDknRn7BVmD8Z8nw==
X-Received: by 2002:a05:600c:1988:b0:40e:ccf7:3618 with SMTP id t8-20020a05600c198800b0040eccf73618mr360779wmq.23.1706307985417;
        Fri, 26 Jan 2024 14:26:25 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id p7-20020a17090628c700b00a3181cb98c7sm1056566ejd.198.2024.01.26.14.26.24
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 14:26:24 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-55a8fb31fc2so739885a12.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:26:24 -0800 (PST)
X-Received: by 2002:aa7:c64d:0:b0:55d:71d8:9dc1 with SMTP id
 z13-20020aa7c64d000000b0055d71d89dc1mr232273edr.38.1706307984490; Fri, 26 Jan
 2024 14:26:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com> <0C9AF227-60F1-4D9B-9099-1A86502359BA@goodmis.org>
In-Reply-To: <0C9AF227-60F1-4D9B-9099-1A86502359BA@goodmis.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 14:26:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=whDnGUm1zAhq7Oa+5BjzjChxObWdy4J4n2TAmMWb_RWtw@mail.gmail.com>
Message-ID: <CAHk-=whDnGUm1zAhq7Oa+5BjzjChxObWdy4J4n2TAmMWb_RWtw@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 14:09, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I'm not at my computer, but when I tried deleting that, it caused issues with the lookup code.

The VSF layer should be serializing all lookups of the same name. If
it didn't, we'd have serious issues on other filesystems.

So you should never get more than one concurrent lookup of one
particular entry, and as long as the dentry exists, you should then
not get a new one. It's one of the things that the VFS layer does to
make things simple for the filesystem.

But it's worth noting that that is about *one* entry. You can get
concurrent lookups in the same directory for different names.

Another thing that worries me is that odd locking that releases the
lock in the middle. I don't understand why you release the
tracefs_mutex() over create_file(), for example. There's a lot of
"take, drop, re-take, re-drop" of that mutex that seems strange.

           Linus
