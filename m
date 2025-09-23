Received: from sender4-g3-154.zohomail360.com (sender4-g3-154.zohomail360.com [136.143.188.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE901A0BD6
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Sep 2025 00:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758674643; cv=pass; b=jCxzmhomDFE0aDMXaTsT5S2NPuJZOlJwn8Ubah3OWhTFVj6QgQbXBJmD4K4MZyTFFey2hTdx8bsNopD8S9+5pwL8XyDTOUtRMyPq6G2+uexEILCnX5ZMBNK3Pk1eEOpv+GFs/2ChD20Xyi76NVVR06w+o7N1cPi5pVedXi0NB+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758674643; c=relaxed/simple;
	bh=W3XVpsyQ6XzOB6rr44hMknLOiGn4Hml2pBmdCJiJ3fA=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=MwKE8Fb25M7mMKjFw0NEskZCuKeSgDJLYFN33SLLXF6azkjNNvpfixe7ISgC3JDPA7BxHR9wwXzrMQK0joroY9d9zd5Fr/jgbi5VmZuIJ2wa/EUIKptgyddVDPuzCOq2c/auN6PkS2pHrIpayEalVwjmfRFM9fLv682ad0IgmuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx; dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b=Nf+Kz5aH; arc=pass smtp.client-ip=136.143.188.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b="Nf+Kz5aH"
ARC-Seal: i=1; a=rsa-sha256; t=1758674641; cv=none; 
	d=us.zohomail360.com; s=zohoarc; 
	b=CVPsLpzsrkdxmjEY6irEb86Hnvhzr9VQdj6e2JpbkiW7kbnxT3gZ0DQGgQxeUfcuQj5UqPQkArVkG3vifaUoEf6px55V+Z3CnPbb7jOvNYKj8Zf1BRMpFsGW0mNdWA5TLIdiGefxT94nAymE4yQkDR08hxK9mSV/NR8AfdOcSaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=us.zohomail360.com; s=zohoarc; 
	t=1758674641; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id:Cc; 
	bh=W3XVpsyQ6XzOB6rr44hMknLOiGn4Hml2pBmdCJiJ3fA=; 
	b=Ig72FoIJsDBw6WoZ4liLB4rppNtnD5APouVCuyRHpHR3rlUmRaneUn5CTUj/5FBRez9nnoG6XqFWf/UNvHI7L2zzpjWc5WtZhC7myszpRNMGfp8CG52wP1Ll2KkU4TO5oBQnIaouAk/HvnQVvYxWnPYUW3GF9O9ah1P2oK+Ba/A=
ARC-Authentication-Results: i=1; mx.us.zohomail360.com;
	dkim=pass  header.i=maguitec.com.mx;
	spf=pass  smtp.mailfrom=investorrelations+9ab55ba0-98d8-11f0-ace3-525400721611_vt1@bounce-zem.maguitec.com.mx;
	dmarc=pass header.from=<investorrelations@maguitec.com.mx>
Received: by mx.zohomail.com with SMTPS id 1758671652802684.4487820553645;
	Tue, 23 Sep 2025 16:54:12 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; b=Nf+Kz5aHK/HWee4gKJjl5evnPnf+kZTu9NAchiOi/S1EklQ3h3D9kqzIc+ynP9bx2WOjBuSENq9CAGvPrR2iKFXs771SLALismfXVohvWMdHVfQsY+ech3SC9f4I1vBSBcuAoSeu6uRyw96sBLk+aDivMAB2q7417b/W2dJetQA=; c=relaxed/relaxed; s=15205840; d=maguitec.com.mx; v=1; bh=W3XVpsyQ6XzOB6rr44hMknLOiGn4Hml2pBmdCJiJ3fA=; h=date:from:reply-to:to:message-id:subject:mime-version:content-type:content-transfer-encoding:date:from:reply-to:to:message-id:subject;
Date: Tue, 23 Sep 2025 16:54:12 -0700 (PDT)
From: Al Sayyid Sultan <investorrelations@maguitec.com.mx>
Reply-To: investorrelations@alhaitham-investment.ae
To: linux-trace-devel@vger.kernel.org
Message-ID: <2d6f.1aedd99b146bc1ac.m1.9ab55ba0-98d8-11f0-ace3-525400721611.19978ffc65a@bounce-zem.maguitec.com.mx>
Subject: Thematic Funds Letter Of Intent
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
content-transfer-encoding-Orig: quoted-printable
content-type-Orig: text/plain;\r\n\tcharset="utf-8"
Original-Envelope-Id: 2d6f.1aedd99b146bc1ac.m1.9ab55ba0-98d8-11f0-ace3-525400721611.19978ffc65a
X-JID: 2d6f.1aedd99b146bc1ac.s1.9ab55ba0-98d8-11f0-ace3-525400721611.19978ffc65a
TM-MAIL-JID: 2d6f.1aedd99b146bc1ac.m1.9ab55ba0-98d8-11f0-ace3-525400721611.19978ffc65a
X-App-Message-ID: 2d6f.1aedd99b146bc1ac.m1.9ab55ba0-98d8-11f0-ace3-525400721611.19978ffc65a
X-Report-Abuse: <abuse+2d6f.1aedd99b146bc1ac.m1.9ab55ba0-98d8-11f0-ace3-525400721611.19978ffc65a@zeptomail.com>
X-ZohoMailClient: External

To: linux-trace-devel@vger.kernel.org
Date: 24-09-2025
Thematic Funds Letter Of Intent

It's a pleasure to connect with you

Having been referred to your investment by my team, we would be=20
honored to review your available investment projects for onward=20
referral to my principal investors who can allocate capital for=20
the financing of it.

kindly advise at your convenience

Best Regards,

Respectfully,
Al Sayyid Sultan Yarub Al Busaidi
Director
