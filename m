Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FAKE_REPLY_C,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0999C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 13:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A9592063F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 13:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rxR6IU9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfEBNVX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 09:21:23 -0400
Received: from mail-yw1-f54.google.com ([209.85.161.54]:43538 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBNVX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 09:21:23 -0400
Received: by mail-yw1-f54.google.com with SMTP id w196so1499660ywd.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 06:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=jKLmgn8BD4GAu4NPp3muQ8tQQzZKKnJf6ZfWnyqiKkk=;
        b=rxR6IU9pvsDvKscL48M1CAWurc7ZBZLQp+0hWyceEOKZVLIoSomv9cMA0ESUv6amV1
         B0uiqQKYgjmrCCvsY0rp5sGokpRZ+3RnuH4RIMabXbAKcl883grsMpzCDjiD6j5746dN
         riTbCz0GR9HSLQtlpyzJoMdVM/S8tvEjJcWk6brLY99YhJ3nPxaHAkEhIyfJuEadWc0S
         jT8uyv01O0kTpqeMR661Iz/cNuDICTi0LrzS1npVx0XNyyYdT/Bvx1d8vEbw4XSYna/g
         jZZo37PxQjqWFayAQwBgeZdW378rTQ6lujNCYqhbcKQtKw4eoMihkhom9xDKqThDR5AN
         LXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jKLmgn8BD4GAu4NPp3muQ8tQQzZKKnJf6ZfWnyqiKkk=;
        b=cTqXNx33YAgRJpqc8oob2TpfaJSnXSfj3F+Sugx6XhlrHqmzoP9eXm/evbFW1JWIMV
         4IjhKVpsq9RW+xIWThoevJBR8uJy6hQ9nZHiNs2rRcZdOWc3BuGe0ThFHJjOIEHbNHIy
         03HYs/kPKMPb6VgZ/P+V8nkK8edyumZuAld/EyMcdDOgS8fboj206soi249KOzc7LJBN
         FGPfVRgB5HaePaxehYFAGnhaQu79yjX3SF9GMMC7p/COX3Ux1cBCqyhllkkwf4LIPDok
         BCCAdEflmeWLnpz9GcDAFW8cRED2CzlHG8QH30ohyYC813+1s4LsrnXEq63FRXtwEZ5A
         Bihw==
X-Gm-Message-State: APjAAAWihGL8AqBwOe9AKjtYQ0VRYYReNzcuBghzeTQuSfqiJdlypo6J
        WJNcfDuSJVtAMd7CXbWogBYdw5yW
X-Google-Smtp-Source: APXvYqxNQAFeNaXxJ4wknjWu1rF/nCWO8bXyQdH2BMCRoEjMEFwzYLf40SpL0ZU8E3xPrmstUAfGIQ==
X-Received: by 2002:a81:7a01:: with SMTP id v1mr3161772ywc.25.1556803282044;
        Thu, 02 May 2019 06:21:22 -0700 (PDT)
Received: from localhost.localdomain ([201.37.66.8])
        by smtp.gmail.com with ESMTPSA id e193sm705983ywh.82.2019.05.02.06.21.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 06:21:21 -0700 (PDT)
Date:   Thu, 2 May 2019 10:21:16 -0300
From:   Ricardo Biehl Pasquali <pasqualirb@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: kernel-shark: logo: Penguin riding a shark
Message-ID: <20190502132116.GA11658@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20190425155338.29b8bbf5@gandalf.local.home>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

version 2

On Thu, Apr 25, 2019 at 03:53:38PM -0400, Steven Rostedt wrote:
> I'm not sure I would have pegged that as a shark ;-), but thanks for
> your submission. I added to the list.

Thank you for the feedback Steven! After a while I wondered
the same thing :-)

Here is another try. Please feel free to send more feedback.

Best regards!

	pasquali

--ew6BAiZeqk4r7MaW
Content-Type: image/svg+xml
Content-Disposition: attachment; filename="kernelshark_logo_v2.svg"
Content-Transfer-Encoding: quoted-printable

<?xml version=3D"1.0" encoding=3D"UTF-8" standalone=3D"no"?>=0A<!-- Created=
 with Inkscape (http://www.inkscape.org/) -->=0A=0A<svg=0A   xmlns:dc=3D"ht=
tp://purl.org/dc/elements/1.1/"=0A   xmlns:cc=3D"http://creativecommons.org=
/ns#"=0A   xmlns:rdf=3D"http://www.w3.org/1999/02/22-rdf-syntax-ns#"=0A   x=
mlns:svg=3D"http://www.w3.org/2000/svg"=0A   xmlns=3D"http://www.w3.org/200=
0/svg"=0A   xmlns:sodipodi=3D"http://sodipodi.sourceforge.net/DTD/sodipodi-=
0.dtd"=0A   xmlns:inkscape=3D"http://www.inkscape.org/namespaces/inkscape"=
=0A   width=3D"297mm"=0A   height=3D"210mm"=0A   viewBox=3D"0 0 297 210"=0A=
   version=3D"1.1"=0A   id=3D"svg8"=0A   inkscape:version=3D"0.92.4 (unknow=
n)"=0A   sodipodi:docname=3D"kernelshark_logo_v2.svg">=0A  <defs=0A     id=
=3D"defs2" />=0A  <sodipodi:namedview=0A     id=3D"base"=0A     pagecolor=
=3D"#ffffff"=0A     bordercolor=3D"#666666"=0A     borderopacity=3D"1.0"=0A=
     inkscape:pageopacity=3D"0.0"=0A     inkscape:pageshadow=3D"2"=0A     i=
nkscape:zoom=3D"0.49497475"=0A     inkscape:cx=3D"308.03663"=0A     inkscap=
e:cy=3D"478.80692"=0A     inkscape:document-units=3D"mm"=0A     inkscape:cu=
rrent-layer=3D"layer6"=0A     showgrid=3D"false"=0A     inkscape:window-wid=
th=3D"1362"=0A     inkscape:window-height=3D"729"=0A     inkscape:window-x=
=3D"0"=0A     inkscape:window-y=3D"37"=0A     inkscape:window-maximized=3D"=
0"=0A     showguides=3D"false"=0A     inkscape:snap-object-midpoints=3D"tru=
e" />=0A  <metadata=0A     id=3D"metadata5">=0A    <rdf:RDF>=0A      <cc:Wo=
rk=0A         rdf:about=3D"">=0A        <dc:format>image/svg+xml</dc:format=
>=0A        <dc:type=0A           rdf:resource=3D"http://purl.org/dc/dcmity=
pe/StillImage" />=0A        <dc:title />=0A      </cc:Work>=0A    </rdf:RDF=
>=0A  </metadata>=0A  <g=0A     inkscape:groupmode=3D"layer"=0A     id=3D"l=
ayer5"=0A     inkscape:label=3D"rear_arm"=0A     style=3D"display:inline">=
=0A    <path=0A       style=3D"opacity:1;fill:#666666;fill-opacity:1;stroke=
:#000000;stroke-width:0.3477689px;stroke-linecap:butt;stroke-linejoin:miter=
;stroke-opacity:1"=0A       d=3D"m 182.92691,57.189135 c -10.92263,30.31946=
7 -45.82978,55.217755 -36.7586,64.177595 4.0745,4.02451 38.56218,-23.754646=
 51.16189,-52.233408"=0A       id=3D"path4484-0"=0A       inkscape:connecto=
r-curvature=3D"0"=0A       sodipodi:nodetypes=3D"csc" />=0A  </g>=0A  <g=0A=
     inkscape:groupmode=3D"layer"=0A     id=3D"layer9"=0A     inkscape:labe=
l=3D"shark_rear_fin"=0A     style=3D"display:inline">=0A    <path=0A       =
style=3D"display:inline;fill:#00b4ff;fill-opacity:1;stroke:#000000;stroke-w=
idth:0.18649592px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:=
1"=0A       d=3D"m 109.09662,147.84879 c 0.82674,13.5379 -1.19205,32.41787 =
3.63635,33.39622 2.45028,0.49651 8.98124,-20.16148 18.69823,-23.81397"=0A  =
     id=3D"path850-6-7"=0A       inkscape:connector-curvature=3D"0"=0A     =
  sodipodi:nodetypes=3D"csc" />=0A  </g>=0A  <g=0A     inkscape:groupmode=
=3D"layer"=0A     id=3D"layer7"=0A     inkscape:label=3D"shark_body"=0A    =
 style=3D"display:inline;opacity:1">=0A    <path=0A       style=3D"display:=
inline;fill:#00b4ff;fill-opacity:1;stroke:#000000;stroke-width:0.3477689px;=
stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"=0A       d=3D"m=
 258.9026,97.937364 c -13.50932,4.377526 -15.61587,23.148066 -31.79498,31.3=
49266 -137.338056,-27.4198 -190.902143,8.52589 -191.070689,18.19042 -0.1357=
76,7.78546 57.742961,37.15599 191.069959,7.08317 15.23555,6.41022 18.14286,=
20.76006 33.78295,27.33854 -6.24592,-26.59125 -6.33352,-54.72209 -1.98724,-=
83.961396 z"=0A       id=3D"path12"=0A       inkscape:connector-curvature=
=3D"0"=0A       sodipodi:nodetypes=3D"ccsccc" />=0A  </g>=0A  <g=0A     ink=
scape:groupmode=3D"layer"=0A     id=3D"layer4"=0A     inkscape:label=3D"sha=
rk_front_fin"=0A     style=3D"display:inline">=0A    <path=0A       style=
=3D"display:inline;fill:#00b4ff;fill-opacity:1;stroke:#000000;stroke-width:=
0.18649592px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"=0A=
       d=3D"m 124.05318,166.70655 c 7.72332,11.14937 15.78173,28.34213 20.4=
1811,26.67642 2.35285,-0.84529 -2.76817,-21.89716 3.64899,-30.05685"=0A    =
   id=3D"path850-6"=0A       inkscape:connector-curvature=3D"0"=0A       so=
dipodi:nodetypes=3D"csc" />=0A    <path=0A       style=3D"display:inline;fi=
ll:#00b4ff;fill-opacity:1;stroke:#000000;stroke-width:0.20618843px;stroke-l=
inecap:butt;stroke-linejoin:miter;stroke-opacity:1"=0A       d=3D"m 134.662=
16,120.2972 c 8.19132,-11.83144 16.13393,-29.711156 21.95949,-28.492058 2.9=
5632,0.618659 -0.99083,22.062068 7.70837,29.577598"=0A       id=3D"path850"=
=0A       inkscape:connector-curvature=3D"0"=0A       sodipodi:nodetypes=3D=
"csc" />=0A  </g>=0A  <g=0A     inkscape:groupmode=3D"layer"=0A     id=3D"l=
ayer8"=0A     inkscape:label=3D"shark_face"=0A     style=3D"display:inline"=
>=0A    <ellipse=0A       style=3D"display:inline;opacity:1;fill:#e6e6e6;fi=
ll-opacity:1;stroke:none;stroke-width:0.65729082;stroke-miterlimit:4;stroke=
-dasharray:none;stroke-opacity:1"=0A       id=3D"path14"=0A       cx=3D"36.=
178497"=0A       cy=3D"160.24661"=0A       rx=3D"6.5230904"=0A       ry=3D"=
5.0014315"=0A       transform=3D"matrix(0.90694811,-0.42124236,0.39994014,0=
=2E91654126,0,0)" />=0A    <ellipse=0A       style=3D"display:inline;opacit=
y:1;fill:#000000;fill-opacity:1;stroke:none;stroke-width:0.12027677;stroke-=
miterlimit:4;stroke-dasharray:none;stroke-opacity:1"=0A       id=3D"path14-=
3"=0A       cx=3D"38.425346"=0A       cy=3D"158.75497"=0A       rx=3D"2.155=
1254"=0A       ry=3D"1.6523936"=0A       transform=3D"matrix(0.90694811,-0.=
42124236,0.39994014,0.91654126,0,0)" />=0A    <path=0A       style=3D"displ=
ay:inline;fill:#e6e6e6;fill-opacity:1;stroke:#000000;stroke-width:0.2645833=
2px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"=0A       d=
=3D"m 69.108012,162.92992 c 18.256494,0.88721 54.848008,1.08679 61.114028,-=
9.1423 -13.37638,7.64852 -48.193802,7.94101 -68.697174,7.32329 z"=0A       =
id=3D"path883"=0A       inkscape:connector-curvature=3D"0"=0A       sodipod=
i:nodetypes=3D"cccc" />=0A  </g>=0A  <g=0A     inkscape:groupmode=3D"layer"=
=0A     id=3D"layer3"=0A     inkscape:label=3D"leg"=0A     style=3D"display=
:inline;opacity:1">=0A    <path=0A       style=3D"fill:#ffe144;fill-opacity=
:1;stroke:#000000;stroke-width:0.2930837px;stroke-linecap:butt;stroke-linej=
oin:miter;stroke-opacity:1"=0A       d=3D"m 163.17801,158.80605 c -10.771,4=
=2E87975 -4.62676,8.69206 4.79149,5.04911 -12.20442,4.65954 -6.18893,9.1765=
 6.19051,3.90265 -14.74193,6.30328 -4.8558,8.78873 5.86209,4.63004 7.92029,=
-3.07319 17.64447,-10.69945 21.62116,-18.43866 3.15244,-6.13508 -2.37868,-8=
=2E44683 -3.06625,-14.08081 l -5.57096,0.67119 c 0.17054,2.03427 0.27175,5.=
39182 -2.70929,6.2577 -16.25667,4.72207 -18.31694,8.01879 -27.11875,12.0087=
8 z"=0A       id=3D"path838"=0A       inkscape:connector-curvature=3D"0"=0A=
       sodipodi:nodetypes=3D"cccssccsc" />=0A  </g>=0A  <g=0A     inkscape:=
label=3D"body"=0A     inkscape:groupmode=3D"layer"=0A     id=3D"layer1"=0A =
    transform=3D"translate(0,-87)"=0A     style=3D"display:inline;opacity:1=
">=0A    <path=0A       style=3D"fill:#666666;fill-opacity:1;stroke:#000000=
;stroke-width:0.3477689px;stroke-linecap:butt;stroke-linejoin:miter;stroke-=
opacity:1"=0A       d=3D"m 174.88998,142.29128 c -3.64054,-53.085125 47.528=
16,-50.136519 41.89294,0.0853 -0.83737,6.31275 7.03201,22.25184 8.91415,43.=
12519 1.72069,19.08283 -19.27654,59.65121 -38.12765,40.80593 -11.69991,-11.=
69629 -14.4113,-19.18309 -22.97848,-18.82321 -5.04495,0.21193 -2.49511,-14.=
40992 -1.51636,-24.66464 1.33829,-14.02182 12.30179,-32.36655 11.8154,-40.5=
2857 z"=0A       id=3D"path10"=0A       inkscape:connector-curvature=3D"0"=
=0A       sodipodi:nodetypes=3D"ccssssc" />=0A  </g>=0A  <g=0A     inkscape=
:groupmode=3D"layer"=0A     id=3D"layer6"=0A     inkscape:label=3D"face"=0A=
     style=3D"display:inline">=0A    <ellipse=0A       style=3D"display:inl=
ine;opacity:1;fill:#e6e6e6;fill-opacity:1;stroke:none;stroke-width:0.377145=
68;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"=0A       id=
=3D"path14-6"=0A       cx=3D"203.71922"=0A       cy=3D"45.246513"=0A       =
rx=3D"5.2415495"=0A       ry=3D"6.6800714"=0A       transform=3D"matrix(0.9=
98507,-0.0546239,0.00571247,0.99998368,0,0)" />=0A    <ellipse=0A       sty=
le=3D"display:inline;opacity:1;fill:#e6e6e6;fill-opacity:1;stroke:none;stro=
ke-width:0.37714568;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacit=
y:1"=0A       id=3D"path14-6-6"=0A       cx=3D"186.75807"=0A       cy=3D"43=
=2E848076"=0A       rx=3D"5.2415495"=0A       ry=3D"6.6800714"=0A       tra=
nsform=3D"matrix(0.998507,-0.0546239,0.00571247,0.99998368,0,0)" />=0A    <=
ellipse=0A       style=3D"display:inline;opacity:1;fill:#000000;fill-opacit=
y:1;stroke:#000000;stroke-width:0.13453661;stroke-miterlimit:4;stroke-dasha=
rray:none;stroke-opacity:1"=0A       id=3D"path14-3-7-2"=0A       cx=3D"190=
=2E18631"=0A       cy=3D"-17.180511"=0A       rx=3D"1.8312272"=0A       ry=
=3D"2.4331067"=0A       transform=3D"matrix(0.9638407,0.2664791,-0.19847385=
,0.98010618,0,0)" />=0A    <path=0A       style=3D"display:inline;opacity:1=
;fill:#ffe144;fill-opacity:1;stroke:#000000;stroke-width:0.40727392px;strok=
e-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"=0A       d=3D"m 182.=
59059,54.794483 c -2.27158,-2.053965 -3.425,-5.865061 0.0865,-7.342764 5.18=
782,-1.734367 8.39601,-6.273405 11.92561,-6.498523 4.70624,-0.300156 8.2017=
6,5.344057 13.15913,6.202165 3.63855,1.244199 2.80712,4.752405 0.21609,7.15=
9194 -3.5997,3.312044 -4.05073,5.353336 -12.64004,5.333305 -8.65504,-0.0202=
5 -9.06881,-1.866057 -12.74724,-4.853377 z"=0A       id=3D"path4400"=0A    =
   inkscape:connector-curvature=3D"0"=0A       sodipodi:nodetypes=3D"ccsccs=
cc" />=0A    <path=0A       style=3D"display:inline;opacity:1;fill:none;str=
oke:#000000;stroke-width:0.31584144px;stroke-linecap:butt;stroke-linejoin:m=
iter;stroke-opacity:1"=0A       d=3D"m 181.6858,50.249424 c 6.26589,5.98198=
9 19.51214,6.175495 26.89488,-0.518453"=0A       id=3D"path4402"=0A       i=
nkscape:connector-curvature=3D"0"=0A       sodipodi:nodetypes=3D"cc" />=0A =
   <ellipse=0A       style=3D"display:inline;opacity:1;fill:#000000;fill-op=
acity:1;stroke:#000000;stroke-width:0.13453661;stroke-miterlimit:4;stroke-d=
asharray:none;stroke-opacity:1"=0A       id=3D"path14-3-7-2-1"=0A       cx=
=3D"207.18828"=0A       cy=3D"-21.249786"=0A       rx=3D"1.8312273"=0A     =
  ry=3D"2.4331067"=0A       transform=3D"matrix(0.9638407,0.2664791,-0.1984=
7385,0.98010618,0,0)" />=0A  </g>=0A  <g=0A     inkscape:groupmode=3D"layer=
"=0A     id=3D"layer2"=0A     inkscape:label=3D"front_arm"=0A     style=3D"=
display:inline">=0A    <path=0A       style=3D"display:inline;opacity:1;fil=
l:#666666;fill-opacity:1;stroke:#000000;stroke-width:0.3477689px;stroke-lin=
ecap:butt;stroke-linejoin:miter;stroke-opacity:1"=0A       d=3D"m 198.04777=
,73.72206 c -10.92264,30.31942 -45.8298,55.21775 -36.75862,64.17759 4.0745,=
4.02451 38.5622,-23.75464 51.16191,-52.233409"=0A       id=3D"path4484"=0A =
      inkscape:connector-curvature=3D"0"=0A       sodipodi:nodetypes=3D"csc=
" />=0A    <text=0A       xml:space=3D"preserve"=0A       style=3D"display:=
inline;opacity:1;font-style:normal;font-weight:normal;font-size:10.58333302=
px;line-height:1.25;font-family:sans-serif;letter-spacing:0px;word-spacing:=
0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:0.26458332"=0A    =
   x=3D"5.9670329"=0A       y=3D"13.610854"=0A       id=3D"text4505"><tspan=
=0A         sodipodi:role=3D"line"=0A         id=3D"tspan4503"=0A         x=
=3D"5.9670329"=0A         y=3D"13.610854"=0A         style=3D"stroke-width:=
0.26458332">2019-04-30</tspan></text>=0A  </g>=0A</svg>=0A
--ew6BAiZeqk4r7MaW--
