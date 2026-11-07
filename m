Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794091349;
	b=gfuKkqeWqs1WuupwoI5q4WjcQBktuyu4cdlpS71g9vVy0fYD4akVsO64izo0AB0w+QCF
	 1JdU4j+4I9DJexqhsGYiv5LzuYTnFyJsnAeEM10AqXNShqNglIQxQjTcdYgCvHQq5KM1U
	 4HtBbfELsECnZx+M+B0HGpzCYNLpUGSyybm0292wytRHlU8OGdybCPdh8E4pmsO/6zRhA
	 PKZisiEt1QZSXaoPoJW68s3C+U3bceWN0LjyCXdj8THJ8vth+JNWtbpFlAjm61LgJj6wz
	 ckssgRpoL0a1ZhuZeK6zfKDxnDJnpA1g19c/4e1RW7aLCcqltZM13LMCQrKZ18cNFww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794091349;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Stat-Signature:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Spam-Status:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=Du8n3t4bB37QtSbniGDx5TkKS3pxFco1uL8D4B7AGbc=;
	b=J0oONPWuFugyzJHrRqSduaZ6PldJEhc7BgXyVt8+5CnrZdWA/2phYcrKvh73gIPXtdpf
	 NqiayUHSm25S+JfIBde4dB/MIvTdyfE8rWp9v+g6pklmq32O1MqBXXI/I3wQn9fLsXsRq
	 XQsZl8cJVxfQcAazE//KPLj5rpWF0QsEK8T9pA62Y21sdNhSwtoh97QCktr7yaFudhrCj
	 vFI8LHFaOwH1CTiRsE+L/Lztq4xmW9+5COgsNVuWjvg863SKjon5UtK9LurKeUIjZYw0U
	 5cEUs23PXxZcEFJpzv3WrZ5uLs83Ih4uFBgNiSYSGNpbt7c6U55WKPDCZzRudsQFV1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=u9K3P3GI;
	arc=none smtp.remote-ip=216.40.44.11
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBED0606A32C
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Nov 2026 22:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBED0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=u9K3P3GI
Received: from omf19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76E7F1203EA;
	Sat,  7 Nov 2026 22:42:27 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 76B3E20026;
	Sat,  7 Nov 2026 22:42:22 +0000 (UTC)
Date: Sat, 7 Nov 2026 17:42:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Pengfei <ljdlns1987@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Pass the pipe size by value to F_SETPIPE_SZ
Message-ID: <20261107174208.6400402e@fedora>
In-Reply-To: <20261107174011.7d86b1de@fedora>
References: <20261107140755.2983258-1-lipengfei28@xiaomi.com>
	<20261107174011.7d86b1de@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s7fhaigf5dugjmgow771k6bw66atdnsj
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 76B3E20026
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19JOJtTgQJxIN9UUaJJe2E6t/QmzelknSI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=Du8n3t4bB37QtSbniGDx5TkKS3pxFco1uL8D4B7AGbc=; b=u9K3P3GIDs+AAf9vndo/5Tn/q4PdaT7ck+pB2B58HOItfq8H3e5Pab6OI4UhCc8m9TQbh03BXoyaJbv8cuR9YeqrAktrbvAhM82hnPXzdH/txoxkIgQZbGtpcMs014pcXTKHWirOTtBRORHFK9bBnhvCYIDSBcJh0eTchrxTrog=
X-HE-Tag: 1794091342-180908
X-HE-Meta: U2FsdGVkX19D0rXP6fXivzsmuhD5ttL0dJ4DtuSMe9Iz5E9iZ3cvaEKOPRShKohUuZXkBXaNv4tbc5oZuRd5KElcVlTybXoKKX5A4G1RqXNONm8uWfx2uwYxa/zG7srcf9CehiQbAY7slECyPHTcm7jd+1j5pHn0RYdpxV+yO8KTVQsn6H11PHH6ZzLSwsONUGrx6HK2RQio3oMJ14bL4j2+zqDgoFaWuOiBycSsGSqSiTcyyPrXf2w7OK2QAr/JB7jmE6xxRqQDurdJS+UanvGTGMr0Mp/DmaBe3HHbKUW7r2SZlTtHZllyL+RpzSoBgUN+0Dld63+5U1TR7J/sfvdmmmi4K4Qxvhykzc+bg/nqKRHqdqmWKlX3DVY59ESt7WtoIyLA+h/Fyx6mk/Cy+1UVHwx/mAJu

On Sat, 7 Nov 2026 17:40:11 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> >  	if (tfs_str_read_file("/proc/sys/fs/pipe-max-size", &buf, false) > 0) {
> >  		int size = atoi(buf);
> > -		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, &size);
> > +
> > +		/* F_SETPIPE_SZ takes the size itself, not a pointer to it */  
> 
> Nit. You don't need to add comments to bug fixes. That is, the above
> comment is useless.

Let me rephrase that. You can add comments to bug fixes. What I meant
was, the above comment is basically stating what was fixed, which is
useless for those looking at the code after the update.

-- Steve

> 
> 
> > +		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, size);
> >  		free(buf);
> >  	}
