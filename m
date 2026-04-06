Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C179020C477
	for <linux-trace-devel@vger.kernel.org>; Mon,  6 Apr 2026 07:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775460854; cv=none; b=qimPDy8RaXfcd5ML2dTx9li8E4Q6EeT+iFVZ/6sr8FkWzJgMgv/FIICGZZV9YvjNxDnDc00EW6aA2As6vxOx6/9RTbMk7w7SHkrYlmvPSSxVP4DHbCn/q1nldmWgfErx87z9INyQtUpA9qAbTXR7PHZAMK6rjwPwgKhQ+qEXxyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775460854; c=relaxed/simple;
	bh=SuMdYuibwXD+lbow1dClhN/tnG/B8pImxe5SwLJ9u/k=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ntE9WC22/3ADJy7doCwpT9T0CC4xgoWdVuSbC0RAG/e8y+kdV1T2Vg+1laBZfaS/EZduog0+MKUANxSod/SzZHR+dsccNXBYTqmN3ufhF7FLRjGFV0/47iKZ4G7gfZd61UE+Pmio3vCDgEhfEpTrgsmRcH/XqqCDTRo8lHiwFfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EcZQj0C9; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EcZQj0C9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:Content-Type:
	MIME-Version; bh=SuMdYuibwXD+lbow1dClhN/tnG/B8pImxe5SwLJ9u/k=;
	b=EcZQj0C9nx1bZ9hZ+5YHxgsIgUooVRS3C7ncrvmy55FWvBXo3SyARDYm5jShZt
	RN514m/QkdXpiMJCVILLFU5LSoPrEyHQf909mEENHAggDxaiL/goxSfojwYxlObG
	T9zlRLK68bP4hY/jU98VFptNseBcjS3LgTeFjyygSTx9o=
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wCX1numYdNp0hS1DQ--.60499S2;
	Mon, 06 Apr 2026 15:32:56 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH] trace-cmd report: keep a separator before long timestamps
Date: Mon, 06 Apr 2026 15:32:54 +0800
Message-ID: <177546077449.67518.4740896792188210053@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:_____wCX1numYdNp0hS1DQ--.60499S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RA6pPUUUUU
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6AjRC2nTYajotgAA3X

A quick follow-up on validation for this patch.

The one remaining "Simple reset" utest failure I mentioned came from
running in the VM against Ubuntu's libtracefs 1.8.0.

Re-running the same trace-cmd utests with upstream libtracefs 1.8.3
makes that test pass as well, and the full trace-cmd utest run becomes
9/9 passed.

So there is no patch change here. This is only a validation note that
the unrelated remaining failure was due to the older libtracefs in the
VM environment.

