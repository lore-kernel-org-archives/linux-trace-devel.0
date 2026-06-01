Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44393AD501
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780323119; cv=none; b=PztUlmnN3rQsIE8nPj9FxFkuCwG4pbWeY48EkR/ii0fbNQt9G7WISo36Zht/UUrs7SzaKVW3qqiuJhpQQvigET31Qm0s7bGSphfyMDvw7Z5ugsr3xwxmF05R9rLdR8Zo+PgwY29KdXFYiL5Gp9ExY/JSYm3x2dcQl6MZQ1vo7vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780323119; c=relaxed/simple;
	bh=j3pO4w9rbv6YtczBuU6dD5HOSyemp62SeObEa73TRcI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIgFZjpRGhVdYCWM/3B1K5x7yHNKO0FwnwRi8PNsPDEqWgvoGd7y3Lm6a1Tg+rNaM6CIZIqZE9Ddi+8nyIHpFGQySja/7ylOyL7LkXJLsWSxcrcuYDdghlzIE/79TS6Xfn1AWE8Qxh70yZx/gZy3YhxsUbzlW8BrynuQM0Iw/Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 254ECA06BC;
	Mon,  1 Jun 2026 14:11:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 4D70B20015;
	Mon,  1 Jun 2026 14:11:49 +0000 (UTC)
Date: Mon, 1 Jun 2026 10:11:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Cao Ruichuang <create0818@163.com>
Cc: linux-trace-devel@vger.kernel.org, Tzvetomir Stoyanov
 <tz.stoyanov@gmail.com>, Emil Thorsoe <ethorsoe@tuxera.com>
Subject: Re: [PATCH 1/2] libtraceevent utest: Handle short reads when
 reading BTF
Message-ID: <20260601101148.24e445e5@fedora>
In-Reply-To: <20260601103750.68805-2-create0818@163.com>
References: <20260601103750.68805-1-create0818@163.com>
	<20260601103750.68805-2-create0818@163.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D70B20015
X-Stat-Signature: d3jc83ohkd7xc1b1gsf5k8gyj6crusnf
X-Rspamd-Server: rspamout03
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18aTIeV54IFLqp/cJvcA24D2qHAmsjBTWk=
X-HE-Tag: 1780323109-492950
X-HE-Meta: U2FsdGVkX1+gByIHmFjsWPUeO3lgvYmc496B7yJXht+3jSLq4Xwz9Y8zupaRsAhTEuv5x6ZJiqGilXHtb2D6qlap0w/ILC/Rzy5eulYzfpme5fmEUwBs6A9Uqd15hqh/66KmlPX3vLVo2sY9pA0vSN88FU0zO9D1XszWJQS3soY8lNi3JB+kz5xL3NTIYYrC7ThzttKo2MzTgj0I5rapDiRZGCDkaWmWUQ+1JAfBsH5MAsUxtUoAvDtP1zzvACYdqGfpuU0QGhNfEofK+1rKMKqQD1zYMoL+7Iz4SucK9ZoyttJQ2I9mnDU+gZ/Bm2Uw148GCzdepW+g+NlGsMHSu71VdARNdEss

On Mon,  1 Jun 2026 18:37:49 +0800
Cao Ruichuang <create0818@163.com> wrote:

> @@ -532,7 +557,13 @@ static void test_btf_read(void)
>  			close(fd);
>  			return;
>  		}
> -		CU_TEST(read(fd, buf, st.st_size) == st.st_size);
> +		ret = read_full(fd, buf, st.st_size);
> +		CU_TEST(ret == 0);

Nit, can you change this to:

		CU_TEST((ret = read_full(fd, buf, st.st_size)) == 0);

so that if it fails, it doesn't just report "ret == 0" in the failure.

I'm working to make the CU_TEST() more informative on failures.

Thanks,

-- Steve


> +		if (ret < 0) {
> +			free(buf);
> +			close(fd);
> +			return;
> +		}
>  	}
