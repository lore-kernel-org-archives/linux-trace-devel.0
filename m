Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA95195801
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594973; cv=none; b=ftXOq2SczInfDp7zpScNhrEAC6rV4gbH/Z4tU/yG+3EDEAfc6DraS/o13wn1kH8ycN0Uz/M5HNlk6uId8TNYiQ3Wu7BkVTHkRrO5OeY8BqZOtulv18bt9PKlr/+i7QHBu9+4XnZUcmPGyujuM4FtP/kjiXO8rTKNWwvOt9giRls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594973; c=relaxed/simple;
	bh=IddH5VtVmvkF9+h14ZgSD+y64cvsrR3U+Kh8AdBd3QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpC2O3Pn0S9tQ14i3Ocxb1oiAD8is438oUMyDjYpqNlirk6ljWyuTGXG9cpC7vedNwaY7bwIeeJBFud/+xu2D2rCvaXdKthoUm9dwpDLcwrON+UWTn//k6H1MXeZp+j/xlR86hnSyd8gKeyRK/U7dF1R6Gd2ZS2XIVO4IAL9xH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWI0PlZY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWI0PlZY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sz3KpoJEylgwtJY8UMmhe/3SgGccN+iYPKn3fXCgayQ=;
	b=GWI0PlZY25KAvSHl6IZGVWKEZvBDao9RAFqWrJRMfMC+H7EflwQ/RcXKfIH/FYdlhuuM8B
	kBt4hVBhGW9Ik9TXerSO5WIGSZZc3Ktrz7Xx9jCeFq7O+wnCXXPWYlyg4oSFuTHkhdofPx
	lSuyY26R/daGJHgfo/vfgD7ERTwBZ18=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-BGuQ5SVhMwSoF-n0dZ41Ow-1; Wed,
 05 Jun 2024 09:42:48 -0400
X-MC-Unique: BGuQ5SVhMwSoF-n0dZ41Ow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D38491C05122;
	Wed,  5 Jun 2024 13:42:47 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 047EC2166AF6;
	Wed,  5 Jun 2024 13:42:45 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:45 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 30/38] trace-cmd listen: prevent memory leak in communicate_with_client()
Date: Wed,  5 Jun 2024 15:40:45 +0200
Message-ID: <20240605134054.2626953-31-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Free option in the error path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-listen.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 09f442c7..da46d09e 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -456,8 +456,10 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 				t = size;
 				s = 0;
 				s = read(fd, option+s, t);
-				if (s <= 0)
+				if (s <= 0) {
+					free(option);
 					goto out;
+				}
 				t -= s;
 				s = size - t;
 			} while (t);
-- 
2.44.0

